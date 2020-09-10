let s:guard = 'g:loaded_autoload_plugins_clap' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Clap setup {{{1
let s:using_icons = v:false

" General settings
let g:clap_multi_selection_warning_silent = 1
let g:clap_enable_icon = !$MOSH_CONNECTION
" let g:clap_use_pure_python = 1  " Set this if vim crashes when looking at files

let g:clap_provider_alias = {
    \ 'map': 'map',
    \ 'scriptnames': 'scriptnames',
    \ }

" Maps
nnoremap <silent> <Leader>t :Clap tags<CR>
nnoremap <silent> <Leader>h :Clap hist:<CR>

command! Filer :Clap filer

function! s:clap_on_enter() abort "{{{2
    augroup ClapEnsureAllClosed
        autocmd!
        autocmd BufEnter,WinEnter,WinLeave * ++once call clap#floating_win#close()
    augroup END
    call s:clap_win_disable_fold()
    if exists('g:loaded_mucomplete')
        silent! MUcompleteAutoOff
        let s:mucomplete_disabled = 1
    endif
endfunction

function! s:clap_on_exit() abort "{{{2
    if exists('s:mucomplete_disabled')
        silent! MUcompleteAutoOn
        unlet s:mucomplete_disabled
    endif
endfunction

function! s:clap_win_disable_fold() abort "{{{2
    let l:clap = get(g:, 'clap')
    if empty(l:clap) | return | endif
    let l:winid = l:clap['display']['winid']
    call setwinvar(l:winid, '&foldenable', 0)
endfunction

" Autocommands {{{2
augroup autoload_plugins_clap
    autocmd!
    " Set autocmd to close clap win if we leave
    autocmd User ClapOnEnter call s:clap_on_enter()
    autocmd User ClapOnExit call s:clap_on_exit()
augroup END

" Clap utils {{{1
function! s:clap_get_selected() abort "{{{2
    let l:curline = g:clap.display.getcurline()
    if g:clap_enable_icon && s:using_icons
        let l:curline = l:curline[4:]
    endif
    return l:curline
endfunction

" Standard file preview with icon support
function! s:clap_file_preview() abort "{{{2
    let l:curline = s:clap_get_selected()
    return clap#preview#file(l:curline)
endfunction

" Standard file edit with icon support
function! s:clap_file_edit(selected) abort "{{{2
    let l:fname = g:clap_enable_icon && s:using_icons ?
        \ a:selected[4:] :
        \ a:selected
    execute 'edit' l:fname
endfunction

" Clap providers {{{1
" Map :: show defined maps for all modes {{{2
" Keep this for now; built-in `maps` provider
" is confusing with which mode is shown
let s:map = {}
let s:map.source = {-> split(execute('map'), '\n')}
let s:map.sink = {-> v:null}
let g:clap#provider#map# = s:map

" help :: search help tags and open help tab {{{2
let s:help = {}

function! s:help.source() abort
    let l:lst = []
    for l:rtp in split(&runtimepath, ',')
        let l:path = glob(l:rtp.'/'.'doc/tags')
        if filereadable(l:path)
            let l:tags = map(readfile(l:path), {_,v-> split(v)[0]})
            call extend(l:lst, l:tags)
        endif
    endfor
    return l:lst
endfunction

let s:help.on_enter = {-> g:clap.display.setbufvar('&ft', 'clap_help')}
let s:help.sink = {v-> execute(window#tab_mod('h', 'help').' '.v)}
let g:clap#provider#help# = s:help

" cmd :: Frequently used commands {{{2
let s:cmds = {
    \ 'ALEInfo': 'ALE debugging info',
    \ 'CocConfig': 'Coc configuration',
    \ 'Scriptnames': 'Runtime scripts sourced',
    \ }
let s:cmd = {}
let s:cmd.source = keys(s:cmds)

function! s:cmd.on_move() abort
    let l:curline = g:clap.display.getcurline()
    call g:clap.preview.show([s:cmds[l:curline]])
endfunction

let s:cmd.sink = {v-> execute(v, '')}
let g:clap#provider#quick_cmd# = s:cmd

" scriptnames :: similar to :Scriptnames {{{2
let s:scriptnames = {}
function! s:scriptnames.source() abort
    let l:names = execute('scriptnames')
    return map(split(l:names, '\n'), {_,v->join(split(v, ':'))})
endfunction

function! s:scriptnames.sink(selected) abort
    let l:fname = split(a:selected, ' ')[-1]
    execute 'edit' trim(l:fname)
endfunction

function! s:scriptnames.on_move() abort
    let l:curline = g:clap.display.getcurline()
    let l:fname = split(l:curline, ' ')[-1]
    return clap#preview#file(l:fname)
endfunction
let s:scriptnames.syntax = 'clap_scriptnames'

let g:clap#provider#scriptnames# = s:scriptnames

" task :: asynctasks.vim list {{{2
let s:task = {}
function! s:task.source() abort
    let l:list = plugins#lazy_call('asynctasks.vim', 'asynctasks#list', '')
    let l:source = []
    let l:longest_name = max(map(copy(l:list), {_,v->len(v['name'])})) + 2
    for l:item in l:list
        let l:source += [
            \ printf('%-'.l:longest_name.'s %-10s :   %s',
            \ l:item['name'],
            \ '<'.l:item['scope'].'>',
            \ l:item['command'])
            \ ]
    endfor
    return l:source
endfunction

function! s:task.sink(selected) abort
    let l:name = split(a:selected, '<')[0]
    let l:name = substitute(l:name, '^\s*\(.\{-}\)\s*$', '\1', '')
    if strlen(l:name)
        execute 'AsyncTask' fnameescape(l:name)
    endif
endfunction
let s:task.syntax = 'clap_task'

let g:clap#provider#task# = s:task

command! Task :Clap task

" dot :: open dotfiles quickly {{{2
let s:dot = {}
function! s:dot.source() abort
    let s:using_icons = v:true
    let l:dotfiles = [
        \ '$DOTFILES/.config/nvim/init.vim',
        \ '$DOTFILES/bashrc.sh',
        \ '$DOTFILES/.config/tmux/tmux.conf',
        \ ]
    let l:fnames = map(l:dotfiles, {_,v->fnamemodify(expand(v), ':~')})
    return map(l:fnames, {_,v->clap#icon#get(v).' '.v})
endfunction

let s:dot.on_move = {->s:clap_file_preview()}
let s:dot.sink = {sel->s:clap_file_edit(sel)}
let g:clap#provider#dot# = s:dot

" mru :: most recently used {{{2
let s:mru = {}

function s:mru.source() abort
    let s:using_icons = v:true
    let l:files = luaeval('require"tools".mru_files()')
    return map(l:files, {_,v->clap#icon#get(v).' '.v})
endfunction

let s:mru.on_move = {->s:clap_file_preview()}
let s:mru.sink = {sel->s:clap_file_edit(sel)}
let g:clap#provider#mru# = s:mru

" history (lua/Viml test) {{{2
function! plugins#clap#history() abort
    let l:hist = filter(
        \ map(range(1, histnr(':')), {v-> histget(':', - v)}),
        \ {v-> !empty(v)}
        \ )
    let l:cmd_hist_len = len(l:hist)
    return map(l:hist, {k,v-> printf('%4d', l:cmd_hist_len - k).'  '.v})
endfunction

" Much faster lua implementation
function! plugins#clap#history_lua() abort
    return luaeval('require("tools").get_history_clap()')
endfunction
" vim:fdl=1:

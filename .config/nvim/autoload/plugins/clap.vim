" Clap setup {{{1
" General settings
let g:clap_always_open_preview = 0
let g:clap_multi_selection_warning_silent = 1
let g:clap_enable_icon = 1
let g:clap_preview_size = 10
let g:clap_enable_background_shadow = v:true
let g:clap_background_shadow_blend = 50
let g:clap_layout = #{
    \ relative: 'editor'
    \ }

" Commands
" command! Buffers Clap buffers
command Task    Clap task
command Filer   Clap filer
command Base16  call plugins#clap#base16()
command Globals Clap globals

call map#cabbr('bs',   'Clap buffers')
call map#cabbr('t',    'Clap tags nvim_lsp')
call map#cabbr('scr',  'Clap scriptnames')
call map#cabbr('mru',  'Clap mru')
call map#cabbr('mapn', 'Clap map ++mode=n')
call map#cabbr('mapi', 'Clap map ++mode=i')
call map#cabbr('mapv', 'Clap map ++mode=v')
call map#cabbr('mapo', 'Clap map ++mode=o')
call map#cabbr('mapx', 'Clap map ++mode=x')
call map#cabbr('api',  'Clap api')

" Maps
nnoremap <Leader>t <Cmd>Clap tags nvim_lsp<CR>
nnoremap <Leader>h <Cmd>Clap command_history<CR>
nnoremap <Leader>m <Cmd>Clap mru<CR>

" Functions {{{1
" function plugins#clap#get_selected() :: Get selection sans icon {{{2
function plugins#clap#get_selected()
    let l:curline = g:clap.display.getcurline()
    if g:clap_enable_icon
        let l:curline = l:curline[4:]
    endif
    return l:curline
endfunction

" function plugins#clap#file_preview() :: File preview with icon support {{{2
function plugins#clap#file_preview()
    let l:curline = plugins#clap#get_selected()
    return clap#preview#file(l:curline)
endfunction

" function plugins#clap#file_edit() :: File edit with icon support {{{2
function plugins#clap#file_edit(selected)
    let l:fname = g:clap_enable_icon ?
        \ a:selected[4:] :
        \ a:selected
    execute 'edit' l:fname
endfunction

" function plugins#clap#base16() :: theme select {{{1
function plugins#clap#base16()
    let g:clap_enable_background_shadow = v:false
    Clap base16
endfunction

" history (lua/Viml test) {{{1
function plugins#clap#history() "{{{2
    let l:hist = filter(
        \ map(range(1, histnr(':')), {v-> histget(':', - v)}),
        \ {v-> !empty(v)}
        \ )
    let l:cmd_hist_len = len(l:hist)
    return map(l:hist, {k,v-> printf('%4d', l:cmd_hist_len - k)..'  '..v})
endfunction

function plugins#clap#history_lua() "{{{2
    return luaeval('require("tools").get_history_clap()')
endfunction
" vim:fdl=1:

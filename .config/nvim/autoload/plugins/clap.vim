if exists('g:loaded_autoload_plugins_clap') | finish | endif
let g:loaded_autoload_plugins_clap = 1

function! plugins#clap#post() abort
    " General settings
    let g:clap_multi_selection_warning_silent = 1
    let g:clap_enable_icon = $MOSH_CONNECTION == 0

    " Keep this for now; built-in `maps` provider
    " is confusing with which mode is shown
    let g:clap#provider#map# = s:maps
    let g:clap#provider#scriptnames# = s:scriptnames

    let g:clap_provider_alias = {
        \ 'map': 'map',
        \ }

    " `:Clap dot` to open some dotfiles quickly.
    let g:clap_provider_dot = {
        \ 'source': [
        \     '$DOTFILES/.config/nvim/init.vim',
        \     '$DOTFILES/bashrc.sh',
        \     '$DOTFILES/.config/tmux/tmux.conf',
        \ ],
        \ 'sink': 'e',
        \ }

    " Maps
    nnoremap <silent> <Leader>t :Clap tags<CR>
    nnoremap <silent> <Leader>h :Clap command_history<CR>
endfunction

function! s:clap_on_enter() abort
    augroup ClapEnsureAllClosed
        autocmd!
        autocmd BufEnter,WinEnter,WinLeave * ++once call clap#floating_win#close()
    augroup END
endfunction

augroup autoload_plugins_clap
    autocmd!
    " Set autocmd to close clap win if we leave
    autocmd User ClapOnEnter call s:clap_on_enter()
augroup END

" Clap providers
" Maps :: show defined maps for all modes
let s:maps = {}
function! s:maps.source() abort
    let l:maps = execute('map')
    return split(l:maps, '\n')
endfunction

function! s:maps.sink(...) abort
    return ''
endfunction

" Scriptnames
let s:scriptnames = {}
function! s:scriptnames.source() abort
    let l:names = execute('scriptnames')
    return split(l:names, '\n')
endfunction

function! s:scriptnames.sink(selected) abort
    let l:fname = split(a:selected, ' ')[-1]
    execute 'edit' trim(l:fname)
endfunction

" History test
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
    return luaeval('require("tools").get_history()')
endfunction

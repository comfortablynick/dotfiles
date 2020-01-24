if exists('g:loaded_autoload_plugins_clap') | finish | endif
let g:loaded_autoload_plugins_clap = 1

function! plugins#clap#post() abort
    " General settings
    let g:clap_multi_selection_warning_silent = 1
    let g:clap_enable_icon = get(g:, 'LL_nf', 0)

    " Providers
    " let g:clap_provider_alias = {
    "     \ 'hist': 'command_history',
    "     \ }

    let g:clap#provider#maps# = s:maps
    let g:clap#provider#scriptnames# = s:scriptnames

    " `:Clap dot` to open some dotfiles quickly.
    let g:clap_provider_dot = {
        \ 'source': [
        \     '~/dotfiles/dotfiles/.config/nvim/init.vim',
        \     '~/dotfiles/dotfiles/bashrc.sh',
        \     '~/dotfiles/dotfiles/tmux.conf',
        \ ],
        \ 'sink': 'e',
        \ }

    " Maps
    nnoremap <silent> <Leader>t :Clap tags<CR>
    nnoremap <silent> <Leader>h :Clap command_history<CR>
endfunction

" Clap providers
" Maps :: show defined maps for all modes
let s:maps = {}
function! s:maps.source() abort
    let l:maps = nvim_exec('map', 1)
    return split(l:maps, '\n')
endfunction

function! s:maps.sink() abort
    return ''
endfunction

" Scriptnames
let s:scriptnames = {}
function! s:scriptnames.source() abort
    let l:names = nvim_exec('scriptnames', 1)
    return split(l:names, '\n')
endfunction

function! s:scriptnames.sink(selected) abort
    let l:fname = split(a:selected, ' ')[-1]
    execute 'edit' trim(l:fname)
endfunction

" History test
function! plugins#clap#history() abort
    let l:hist = filter(map(range(1, histnr(':')), 'histget(":", - v:val)'), '!empty(v:val)')
    let cmd_hist_len = len(l:hist)
    return map(l:hist, 'printf("%4d", cmd_hist_len - v:key)."  ".v:val')
endfunction

" Much faster lua implementation
function! plugins#clap#history_lua() abort
    return luaeval('require("tools").get_history()')
endfunction

" ====================================================
" Filename:    plugin/pack.vim
" Description: Interface with packages and package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-25 19:08:39 CST
" ====================================================
if exists('g:loaded_plugin_pack') || exists('g:no_load_plugins') | finish | endif
let g:loaded_plugin_pack = 1

let g:package_manager = 'vim-packager'

" Call minpac or minpac wrappers
command! -bang PackUpdate call plugins#init() | call pack#update({'force_hooks': <bang>0})
command!       PackClean  call plugins#init() | call pack#clean()
command!       PackStatus call plugins#init() | call pack#status()

function! s:deferred_load(...) abort
    let g:pack_deferred = get(g:, 'pack_deferred', [])
    for pack in g:pack_deferred
        execute 'silent! packadd' pack
    endfor
    " Load local vimrc if env var
    if exists('*localrc#load_from_env')
        call localrc#load_from_env()
    endif
endfunction

augroup deferred_pack_load
    autocmd!
    autocmd VimEnter * ++once call timer_start(200, { -> s:deferred_load() })
augroup END

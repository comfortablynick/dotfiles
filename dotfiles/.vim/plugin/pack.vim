" ====================================================
" Filename:    plugin/pack.vim
" Description: Interface with packages and package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-12 09:31:56 CST
" ====================================================
if exists('g:loaded_plugin_pack') || exists('g:no_load_plugins') | finish | endif
let g:loaded_plugin_pack = 1

let g:package_manager = 'vim-packager'

let g:package_defer_time = 200

" Call minpac or minpac wrappers
command! -bang PackUpdate call plugins#init() | call pack#update({'force_hooks': <bang>0})
command!       PackClean  call plugins#init() | call pack#clean()
command!       PackStatus call plugins#init() | call pack#status()

augroup deferred_pack_load
    autocmd!
    autocmd VimEnter * ++once call timer_start(g:package_defer_time, { -> s:deferred_load() })
augroup END

" Load packages that are safe to defer
function! s:deferred_load() abort
    silent! packadd targets.vim
    silent! packadd ale
    silent! packadd tcomment_vim
    silent! packadd asyncrun.vim

    if $MOSH_CONNECTION != 1
        packadd vim-devicons
    endif

    if index(g:completion_filetypes.coc, &filetype) < 0
        packadd vim-gitgutter
    endif

    " Load local vimrc if env var
    call localrc#load_from_env()
endfunction

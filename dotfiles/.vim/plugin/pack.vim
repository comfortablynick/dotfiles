" ====================================================
" Filename:    plugin/pack.vim
" Description: Interface with packages and package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:53:53 CST
" ====================================================
if exists('g:loaded_plugin_pack_gdjlcrz2') 
    \ || exists('g:no_load_plugins')
    finish 
endif
let g:loaded_plugin_pack_gdjlcrz2 = 1

let g:package_manager = 'vim-packager'

" Call minpac or minpac wrappers
command! -bang PackUpdate call plugins#init() | call pack#update({'force_hooks': <bang>0})
command!       PackClean  call plugins#init() | call pack#clean()
command!       PackStatus call plugins#init() | call pack#status()

" ====================================================
" Filename:    plugin/pack.vim
" Description: Interface with packages and package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-04
" ====================================================
if exists('g:loaded_plugin_pack_gdjlcrz2') | finish | endif
let g:loaded_plugin_pack_gdjlcrz2 = 1

let g:package_manager = 'vim-packager'

" Call minpac or minpac wrappers
command! -bang PackUpdate call plugins#init() | call pack#update({'force_hooks': <bang>0})
command!       PackClean  call plugins#init() | call pack#clean()
command!       PackStatus call plugins#init() | call pack#status()

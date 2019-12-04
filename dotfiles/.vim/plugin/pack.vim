" ====================================================
" Filename:    plugin/pack.vim
" Description: Interface with packages and package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-04
" ====================================================

" Call minpac or minpac wrappers
command! PackUpdate call pack#update()
command! PackClean  call pack#clean()
command! PackStatus call pack#status()

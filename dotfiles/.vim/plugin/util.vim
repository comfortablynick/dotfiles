" ====================================================
" Filename:    plugin/util.vim
" Description: Misc. utilities
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-07 17:47:48 CST
" ====================================================
if exists('g:loaded_plugin_util') | finish | endif
let g:loaded_plugin_util = 1

" Usage:
" 	:Redir hi .........show the full output of command ':hi' in a scratch window
" 	:Redir !ls -al ....show the full output of command ':!ls -al' in a scratch window
command! -nargs=1 -complete=command Redir silent call util#redir(<q-args>)

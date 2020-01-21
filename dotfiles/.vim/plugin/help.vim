" ====================================================
" Filename:    plugin/help.vim
" Description: Help commands and maps
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-21 14:30:29 CST
" ====================================================
if exists('g:loaded_plugin_help_lljwt1mi') | finish | endif
let g:loaded_plugin_help_lljwt1mi = 1

" Floating help window
command! -complete=help -nargs=? Help lua require'window'.floating_help(<q-args>)
command! -complete=help -nargs=? H Help <args>

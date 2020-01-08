" ====================================================
" Filename:    plugin/vista.vim
" Description: Vista explorer configuration
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 07:59:36 CST
" ====================================================
if exists('g:loaded_plugin_vista_xuwor4nb') | finish | endif
let g:loaded_plugin_vista_xuwor4nb = 1

nnoremap <silent> <Leader>v :call config#vista#run('toggle')<CR>
nnoremap <silent> <Leader>m :call config#vista#run('finder')<CR>

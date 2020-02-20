" ====================================================
" Filename:    after/ftplugin/json.vim
" Description: json(c) settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-12
" ====================================================
if exists('g:loaded_ftplugin_json_dmqqttrg') | finish | endif
let g:loaded_ftplugin_json_dmqqttrg = 1

setlocal shiftwidth=2
setlocal tabstop=3

" Must be in /after to override nvim commentstring (blank)
setlocal commentstring=//%s

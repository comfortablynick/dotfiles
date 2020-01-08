" ====================================================
" Filename:    plugin/file.vim
" Description: File-related commands
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-07
" ====================================================
if exists('g:loaded_plugin_file_qjxx1opc') | finish | endif
let g:loaded_plugin_file_qjxx1opc = 1

" Timestamp YYYY-MM-DD
let g:timestamp_format = '%F'

augroup plugin_file_qjxx1opc
    autocmd!
    " auto-update the timestamp right before saving a file
    autocmd! BufWritePre * :call file#update_timestamp()
augroup END

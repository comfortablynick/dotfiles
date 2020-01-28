" ====================================================
" Filename:    plugin/file.vim
" Description: File-related commands
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-27 15:30:31 CST
" ====================================================
if exists('g:loaded_plugin_file_qjxx1opc')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_file_qjxx1opc = 1

" Timestamp YYYY-MM-DD HH:MM:SS CST
let g:timestamp_format = '%F %H:%M:%S %Z'
augroup plugin_file_qjxx1opc
    autocmd!
    " auto-update the timestamp right before saving a file
    autocmd BufWritePre * if &modified | :call file#update_timestamp() | endif
    autocmd BufWritePre * let &backupext = '@'.strftime('%F.%H:%M')
augroup END

" ====================================================
" Filename:    plugin/file.vim
" Description: File-related commands
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-03-02 14:26:39 CST
" ====================================================
let s:guard = 'g:loaded_plugin_file' | if exists(s:guard) | finish | endif
let {s:guard} = 1
" if !util#guard(expand('<sfile>')) | finish | endif

command! -nargs=0 -complete=file SetExecutable call file#set_executable_bit()

" Timestamp YYYY-MM-DD HH:MM:SS CST
let g:timestamp_format = '%F %H:%M:%S %Z'
augroup plugin_file
    autocmd!
    " auto-update the timestamp right before saving a file
    autocmd BufWritePre * if &modified | :call file#update_timestamp() | endif
    autocmd BufWritePre * let &backupext = '@'.strftime('%F.%H:%M')
augroup END

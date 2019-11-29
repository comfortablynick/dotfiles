" ====================================================
" Filename:    plugin/config/help.vim
" Description: Custom help config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-11-29
" ====================================================

if exists('g:loaded_help_vim_zxknd8ic') | finish | endif
let g:loaded_help_vim_zxknd8ic = 1

" Open help in large window
command! -nargs=? -complete=help Help :help <args> | :wincmd o
command! -nargs=? -complete=help H :help <args> | :wincmd o

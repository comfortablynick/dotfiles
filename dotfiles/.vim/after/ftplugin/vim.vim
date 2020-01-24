" ====================================================
" Filename:    after/ftplugin/vim.vim
" Description: Vim script files
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-24 07:37:06 CST
" ====================================================
if exists('g:loaded_after_ftplugin_vim_xsakimlh') | finish | endif
let g:loaded_after_ftplugin_vim_xsakimlh = 1

" Local vim editor settings
setlocal tabstop=4                                              " Treat spaces as tab
let g:vim_indent_cont = &tabstop                                " Indent \ newline escapes
setlocal foldmethod=marker                                      " Fold using markers
setlocal formatoptions-=o                                       " Don't insert comment marker automatically on O, o
setlocal formatoptions-=r                                       " Don't insert comment marker automatically on <Enter>

" ====================================================
" Filename:    ftplugin/qf.vim
" Description: Quickfix window filetype settings/commands
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-28 15:15:14 CST
" ====================================================
if exists('g:loaded_ftplugin_quickfix') | finish | endif
let g:loaded_ftplugin_quickfix = 1

if !exists(':Cfilter')
    silent! packadd cfilter
endif

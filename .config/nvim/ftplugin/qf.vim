" ====================================================
" Filename:    ftplugin/qf.vim
" Description: Quickfix window filetype settings/commands
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-27 16:21:45 CST
" ====================================================
let s:guard = 'g:loaded_ftplugin_qf' | if exists(s:guard) | finish | endif
let {s:guard} = 1

if !exists(':Cfilter') | packadd cfilter | endif

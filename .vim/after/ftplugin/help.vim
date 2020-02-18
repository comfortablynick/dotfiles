" ====================================================
" Filename:    after/ftplugin/help.vim
" Description: Settings/overrides for help filetypes
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-18 16:44:41 CST
" ====================================================
if exists('g:loaded_after_ftplugin_help') | finish | endif
let g:loaded_after_ftplugin_help = 1

augroup after_ftplugin_help
    " Clear all buffer autocmds for this ftplugin
    " See: https://vi.stackexchange.com/a/13456
    autocmd! * <buffer>
    " Maximize help window
    autocmd BufWinEnter <buffer> wincmd o
augroup END

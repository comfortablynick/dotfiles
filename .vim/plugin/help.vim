" ====================================================
" Filename:    plugin/help.vim
" Description: Help commands and maps
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-21 20:25:19 CST
" ====================================================
if exists('g:loaded_plugin_help_lljwt1mi') | finish | endif
let g:loaded_plugin_help_lljwt1mi = 1

" Floating help window
command! -complete=help -nargs=? Help lua require'window'.floating_help(<q-args>)
command! -complete=help -nargs=? H Help <args>

augroup plugin_help_lljwt1mi
    " Maximize help window
    autocmd BufWinEnter * if &l:buftype ==# 'help' | wincmd o | endif
augroup END

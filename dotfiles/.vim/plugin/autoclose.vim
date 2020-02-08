" ====================================================
" Filename:    plugin/autoclose.vim
" Description: Autoclose windows if they are last ones open
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-07 17:54:23 CST
" ====================================================
if exists('g:loaded_plugin_autoclose') | finish | endif
let g:loaded_plugin_autoclose = 1

" Autoclose vim if last window is not a file
" Original script from: https://stackoverflow.com/a/39307414/10370751
let g:autoclose_buftypes = [
    \ 'quickfix',
    \ 'help',
    \ 'nofile',
    \ ]
let g:autoclose_filetypes = [
    \ 'qf',
    \ 'help',
    \ 'vista',
    \ 'minpac',
    \ 'vim-plug',
    \ 'coc-explorer',
    \ 'defx',
    \ ]

" autoclose last open location/quickfix/help windows on a tab
augroup plugin_autoclose
    autocmd!
    autocmd WinEnter * ++nested call autoclose#quit_if_only_window()
augroup END

" ====================================================
" Filename:    plugin/autoclose.vim
" Description: Autoclose windows if they are last ones open
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-05
" ====================================================
if exists('g:loaded_plugin_autoclose_t3h7fvur') | finish | endif
let g:loaded_plugin_autoclose_t3h7fvur = 1

" Autoclose vim if last window is not a file
" Original script from: https://stackoverflow.com/a/39307414/10370751
let g:autoclose_buftypes = ['quickfix', 'help']
let g:autoclose_filetypes = ['qf', 'help', 'vista', 'minpac', 'vim-plug']

" autoclose last open location/quickfix/help windows on a tab
augroup plugin_autoclose_t3h7fvur
    autocmd!
    autocmd WinEnter * nested call autoclose#quit_if_only_window()
augroup END

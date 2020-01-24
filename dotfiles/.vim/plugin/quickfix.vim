" ====================================================
" Filename:    plugin/quickfix.vim
" Description: Commands for quickfix window
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-24 07:38:22 CST
" ====================================================
if exists('g:loaded_plugin_quickfix_9wgejmpc')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_quickfix_9wgejmpc = 1

" Close qf after lint if empty
augroup plugin_quickfix_9wgejmpc
    autocmd!
    autocmd User ALELintPost call quickfix#close_empty()
    autocmd FileType qf wincmd J
augroup end

nnoremap <silent> <Leader>q :call quickfix#toggle()<CR>

" Load rtp in quickfix
command! Scriptnames packadd vim-scriptease<bar>Scriptnames

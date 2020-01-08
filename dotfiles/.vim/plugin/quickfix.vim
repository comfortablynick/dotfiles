" ====================================================
" Filename:    plugin/quickfix.vim
" Description: Commands for quickfix window
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:54:46 CST
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
noremap  <silent> <F10>     :call quickfix#toggle()<CR>

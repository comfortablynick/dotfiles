" ====================================================
" Filename:    plugin/tagbar.vim
" Description: Tagbar tag explorer lazy load/config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:55:58 CST
" ====================================================
if exists('g:loaded_plugin_tagbar_8ftwpz9y')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_tagbar_8ftwpz9y = 1

" Lazy load tagbar (only call through these maps)
nnoremap <silent> <Leader>t :call config#tagbar#tagbar_toggle()<CR>
noremap <silent> <F8> :call config#tagbar#tagbar_toggle()<CR>

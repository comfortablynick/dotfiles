" ====================================================
" Filename:    plugin/undotree.vim
" Description: Set maps and commands for undotree
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-24 06:09:27 CST
" ====================================================
if exists('g:loaded_plugin_undotree_zjjpnxtn')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_undotree_zjjpnxtn = 1

" Lazy load undotree when first called
command! UndotreeToggle packadd undotree|UndotreeToggle|UndotreeFocus

noremap <silent> <F5> :UndotreeToggle<CR>

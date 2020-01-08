" ====================================================
" Filename:    plugin/minimap.vim
" Description: Show minimap similar to vscode/atom
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:52:29 CST
" ====================================================
if exists('g:loaded_minimap_vim_bdvqdpri')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_minimap_vim_bdvqdpri = 1

lua mm = require('minimap')

command! Minimap lua mm.show_minimap()
command! MinimapUpdate lua mm.update_minimap()

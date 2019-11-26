" ====================================================
" Filename:    plugin/minimap.vim
" Description: Show minimap similar to vscode/atom
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-11-26
" ====================================================
if exists('g:loaded_minimap_vim_bdvqdpri') | finish | endif
let g:loaded_minimap_vim_bdvqdpri = 1

lua mm = require('minimap')

command! Minimap lua mm.show_minimap()
command! MinimapUpdate lua mm.update_minimap()

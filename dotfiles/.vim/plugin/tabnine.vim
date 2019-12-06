" ====================================================
" Filename:    plugin/tabnine.vim
" Description: Tabnine completion plugin config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-06
" ====================================================
if exists('g:loaded_plugin_tabnine_mikt08z7') | finish | endif
let g:loaded_plugin_tabnine_mikt08z7 = 1

augroup plugin_tabnine_mikt08z7
    autocmd!
    autocmd vimrc FileType *
        \ if index(g:completion_filetypes['tabnine'], &filetype) >= 0
        \ | packadd tabnine-vim
        \ | endif
augroup END

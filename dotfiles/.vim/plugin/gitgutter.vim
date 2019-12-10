" ====================================================
" Filename:    plugin/gitgutter.vim
" Description: Gitgutter config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-06
" ====================================================
if exists('g:loaded_plugin_gitgutter_9vbutkh3') | finish | endif
let g:loaded_plugin_gitgutter_9vbutkh3 = 1

" Don't load if we're using coc (use coc-git instead)
augroup plugin_gitgutter_9vbutkh3
    autocmd!
    autocmd FileType *
        \ if exists('g:completion_filetypes')
        \ && index(g:completion_filetypes['coc'], &filetype) < 0
        \ | packadd vim-gitgutter
        \ | endif
augroup END

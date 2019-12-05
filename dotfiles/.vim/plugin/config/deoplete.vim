" ====================================================
" Filename:    plugin/config/deoplete.vim
" Description: Deoplete completion plugin config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-05
" ====================================================
if exists('g:loaded_plugin_config_deoplete_jdh6forp') | finish | endif
let g:loaded_plugin_config_deoplete_jdh6forp = 1

" Load deoplete
augroup deoplete_config
    autocmd!
    autocmd FileType *
        \ if exists('g:completion_filetypes') &&
        \ index(g:completion_filetypes['deoplete'], &filetype) >= 0
        \ | call config#deoplete#init()
        \ | endif
augroup END

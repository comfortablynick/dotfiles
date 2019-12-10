" ====================================================
" Filename:    plugin/fugitive.vim
" Description: vim-fugitive config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-10
" ====================================================
if exists('g:loaded_plugin_fugitive_hpnu0lrb') || !exists(':Git')
    finish
endif
let g:loaded_plugin_fugitive_hpnu0lrb = 1

" Fugitive merge conflicts
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>

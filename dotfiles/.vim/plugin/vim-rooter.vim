" ====================================================
" Filename:    plugin/vim-rooter.vim
" Description: vim-rooter settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:57:28 CST
" ====================================================
if exists('g:loaded_plugin_vim_rooter_yn1jd5hw') | finish | endif
let g:loaded_plugin_vim_rooter_yn1jd5hw = 1

let g:rooter_manual_only = 1
let g:rooter_patterns = [
    \ '.clasp.json',
    \ '.git',
    \ '.git/',
    \ 'package-lock.json',
    \ 'package.json',
    \ 'tsconfig.json'
    \ ]

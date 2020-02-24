" ====================================================
" Filename:    ftplugin/markdown.vim
" Description: Markdown ft settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-21 16:19:58 CST
" ====================================================
if exists('g:loaded_ftplugin_markdown') | finish | endif
let g:loaded_ftplugin_markdown = 1

setlocal tabstop=2
setlocal spell

" Mkdx plugin settings
let g:mkdx#settings = {
    \ 'fold': {'enable': 0},
    \ 'toc':  {
    \       'position': 2,
    \       'text': 'Table of Contents',
    \       'update_on_write': 0,
    \   },
    \ 'enter': {'shift': 1},
    \ }

" vim-markdown-folding settings
let g:markdown_fold_override_foldtext = 0

function! MarkdownFoldLevel() abort
    " WIP: only increases fold level, never decreases
    let l:currline = getline(v:lnum)
    if l:currline =~# '^## .*$'     | return '>1' | endif
    if l:currline =~# '^### .*$'    | return '>2' | endif
    if l:currline =~# '^#### .*$'   | return '>3' | endif
    if l:currline =~# '^##### .*$'  | return '>4' | endif
    if l:currline =~# '^###### .*$' | return '>5' | endif
    return '='
endfunction

setlocal foldexpr=MarkdownFoldLevel()
setlocal foldmethod=expr
setlocal foldlevel=1

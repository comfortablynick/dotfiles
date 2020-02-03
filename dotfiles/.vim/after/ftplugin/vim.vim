" ====================================================
" Filename:    after/ftplugin/vim.vim
" Description: Vim script files
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-02 22:59:01 CST
" ====================================================

" Local vim editor settings
setlocal tabstop=4                                              " Treat spaces as tab
let g:vim_indent_cont = &tabstop                                " Indent \ newline escapes
setlocal formatoptions-=o                                       " Don't insert comment marker automatically on O, o
setlocal formatoptions-=r                                       " Don't insert comment marker automatically on <Enter>

" Folding
setlocal foldmethod=marker                                      " Fold using markers
setlocal foldexpr=VimFoldLevel()

function! VimFoldLevel() abort
    let marker = split(&foldmarker, ',')[0]
    let line = getline(v:lnum)
    " Functions
    if line =~# '\v^\s*fun'
        return '>1'
    endif
    " Modeline (don't fold)
    if line =~# '\v^\"\s*vim:'
        return '0'
    endif
    " Markers
    "TODO: extract number for level
    if line =~# '\v\{\{\{\d*$'
        return '>1'
    endif
    return '='
endfunction

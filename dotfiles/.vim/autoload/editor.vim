" ====================================================
" Filename:    autoload/editor.vim
" Description: General editor behavior functions
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-16 08:28:15 CST
" ====================================================

" Expand cabbr if it's the only command
function! editor#cabbr(lhs, rhs) abort
    if getcmdtype() ==# ':' && getcmdline() == a:lhs
        return a:rhs
    endif
    return a:lhs
endfunction

" Eat space (from h: abbr)
function! editor#eatchar(pat) abort
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunc

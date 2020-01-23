" ====================================================
" Filename:    autoload/editor.vim
" Description: General editor behavior functions
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-22 11:25:42 CST
" ====================================================

" Restore cursor position after motion
function! editor#restore_cursor_after(motion) abort
    let l:wv = winsaveview()
    execute 'normal! '.a:motion
    call winrestview(l:wv)
endfunction

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

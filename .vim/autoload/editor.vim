" ====================================================
" Filename:    autoload/editor.vim
" Description: General editor behavior functions
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-18 17:29:46 CST
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

function! editor#iabbr(lhs, rhs) abort
    return a:rhs
endfunction

" Eat space (from h: abbr)
function! editor#eatchar(pat) abort
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunc

" Insert fold marker + comment string if not already in comment
function! editor#foldmarker() abort
    let l:open = matchstr(&foldmarker, '^[^,]*')
    if syntax#is_comment_line()
        let l:out = l:open
    else
        let l:out = printf(&commentstring, l:open)
    endif
    return l:out."\<C-R>=editor#eatchar('\s')\<CR>"
endfunction

" Close buffer if not modifiable; quit if last buf
" Map this fn to q for desired filetypes
function! editor#quick_close_buffer() abort
    if &l:modifiable
        echohl WarningMsg echo "Cannot use 'q' on modifiable buffer"
        return
    endif
    if bufnr('$') == 1
        quit
    else
        bdelete
    endif
endfunction

" editor#restore_cursor_after() :: Restore cursor position after motion {{{1
function editor#restore_cursor_after(motion)
    let l:wv = winsaveview()
    execute 'normal! '.a:motion
    call winrestview(l:wv)
endfunction

" editor#foldmarker() :: Return fold marker + comment string if not already in comment {{{1
function editor#foldmarker()
    let l:open = matchstr(&foldmarker, '^[^,]*')
    return syntax#is_comment_line() ? l:open : printf(&commentstring, l:open)
endfunction

" editor#quick_close_buffer() :: Close buffer if not modifiable; quit if last buf {{{1
" Map this fn to q for desired filetypes
function editor#quick_close_buffer()
    if &l:modifiable
        echohl WarningMsg echo "Cannot use 'q' on modifiable buffer"
        return
    endif
    if bufnr('$') == 1
        quit
    else
        bwipeout
    endif
endfunction

" ====================================================
" Filename:    autoload/editor.vim
" Description: General editor behavior functions
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-25 21:39:24 CST
" ====================================================

" Restore cursor position after motion
function! editor#restore_cursor_after(motion) abort
    let l:wv = winsaveview()
    execute 'normal! '.a:motion
    call winrestview(l:wv)
endfunction

" Expand cabbr if it's the only command
function! editor#cabbr(lhs, rhs) abort
    if getcmdtype() ==# ':' && getcmdline() ==# a:lhs
        return a:rhs
    endif
    return a:lhs
endfunction

" Eat space (from h: abbr)
function! editor#eatchar(pat) abort
    let l:c = nr2char(getchar(0))
    return (l:c =~ a:pat) ? '' : l:c
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
        bwipeout
    endif
endfunction

" Show help in tab if only 'h' is used
" From: https://github.com/airblade/vim-helptab
function! editor#help_tab() abort
    if !(getcmdtype() == ':' && getcmdpos() <= 2)
        return 'h'
    endif

    let l:helptabnr = 0
    for l:i in range(tabpagenr('$'))
        let l:tabnr = l:i + 1
        for l:bufnr in tabpagebuflist(l:tabnr)
            if getbufvar(l:bufnr, '&ft') ==# 'help'
                let l:helptabnr = l:tabnr
                break
            endif
        endfor
    endfor

    if l:helptabnr
        if tabpagenr() == l:helptabnr
            return 'h'
        else
            return 'tabnext '.l:helptabnr.' | h'
        endif
    else
        return 'tab h'
    endif
endfunction

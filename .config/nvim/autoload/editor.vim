" ====================================================
" Filename:    autoload/editor.vim
" Description: Editor behavior functions
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_autoload_editor' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" editor#restore_cursor_after() :: Restore cursor position after motion {{{1
function! editor#restore_cursor_after(motion) abort
    let l:wv = winsaveview()
    execute 'normal! '.a:motion
    call winrestview(l:wv)
endfunction

" editor#foldmarker() :: Return fold marker + comment string if not already in comment {{{1
function! editor#foldmarker() abort
    let l:open = matchstr(&foldmarker, '^[^,]*')
    return syntax#is_comment_line() ? l:open : printf(&commentstring, l:open)
endfunction

" editor#quick_close_buffer() :: Close buffer if not modifiable; quit if last buf {{{1
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

" editor#help_tab() :: Show help in new or existing tab {{{1
" From: https://github.com/airblade/vim-helptab
function! editor#help_tab() abort
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

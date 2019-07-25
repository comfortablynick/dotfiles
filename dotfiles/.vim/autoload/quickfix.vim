" Quickfix window functions
" Toggle quickfix window
function! quickfix#toggle() abort
    if exists('*asyncrun#quickfix_toggle')
        " AsyncRun is loaded; use this handy function
        " Open qf window of specific size in most elegant way
        let qf_lines = len(getqflist())
        let qf_size = qf_lines ?
            \ min([qf_lines, get(g:, 'quickfix_size', 12)]) :
            \ 1
        call asyncrun#quickfix_toggle(qf_size)
        return
    endif
    for buffer in tabpagebuflist()
        if bufname(buffer) ==? ''
          " then it should be the quickfix window
          cclose
          return
        endif
    endfor
    " Quickfix window not open, so open it
    copen
endfunction

" Close an empty quickfix window
function! quickfix#close_empty() abort
    if len(getqflist())
        return
    endif
    for buffer in tabpagebuflist()
        if bufname(buffer) ==? ''
            call quickfix#toggle()
            return
        endif
    endfor
endfunction

" Return 1 if quickfix window is open, else 0
function! quickfix#is_open() abort
    for buffer in tabpagebuflist()
        if bufname(buffer) ==? ''
            return 1
        endif
    endfor
    return 0
endfunction

" Close quickfix on quit
" (Use autoclose script instead)
function! quickfix#autoclose() abort
    if &filetype ==? 'qf'
        " if this window is last on screen quit without warning
        if winnr('$') < 2
            quit
        endif
    endif
endfunction

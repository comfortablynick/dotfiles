" Quickfix window functions
" Toggle quickfix window
let s:guard = 'g:loaded_autoload_quickfix' | if exists(s:guard) | finish | endif
let {s:guard} = 1

let s:quickfix_size = 20

" Show :scriptnames in quickfix list and optionally filter
function! quickfix#scriptnames(...) abort
    call setqflist([], ' ', {'items': util#scriptnames(), 'title': 'Scriptnames'})
    if len(a:000) > 0
        if !exists(':Cfilter') | packadd cfilter | endif
        for l:arg in a:000
            execute 'Cfilter' l:arg
        endfor
    endif
endfunction

" Originally from:
" https://github.com/skywind3000/asyncrun.vim/blob/master/plugin/asyncrun.vim
function! s:qf_toggle(size, ...)
    let l:mode = (a:0 == 0)? 2 : (a:1)
    function! s:window_check(mode)
        if &l:buftype ==# 'quickfix'
            let s:quickfix_open = 1
            return
        endif
        if a:mode == 0
            let w:quickfix_save = winsaveview()
        else
            if exists('w:quickfix_save')
                call winrestview(w:quickfix_save)
                unlet w:quickfix_save
            endif
        endif
    endfunc
    let s:quickfix_open = 0
    let l:winnr = winnr()
    noautocmd windo call s:window_check(0)
    noautocmd silent! execute l:winnr 'wincmd w'
    if l:mode == 0
        if s:quickfix_open != 0
            silent! cclose
        endif
    elseif l:mode == 1
        if s:quickfix_open == 0
            execute 'botright copen' a:size > 0 ? a:size : ''
            wincmd k
        endif
    elseif l:mode == 2
        if s:quickfix_open == 0
            execute 'botright copen' a:size > 0 ? a:size : ''
            wincmd k
        else
            silent! cclose
        endif
    endif
    noautocmd windo call s:window_check(1)
    noautocmd silent! execute l:winnr 'wincmd w'
endfunction

function! quickfix#toggle() abort
    let l:qf_lines = len(getqflist())
    let l:qf_size = min([max([1, l:qf_lines]), get(g:, 'quickfix_size', s:quickfix_size)])
    call s:qf_toggle(l:qf_size)
endfunction

function! quickfix#open() abort
    let l:qf_lines = len(getqflist())
    let l:qf_size = min([max([1, l:qf_lines]), get(g:, 'quickfix_size', s:quickfix_size)])
    execute 'copen' l:qf_size
    wincmd k
endfunction

" Close an empty quickfix window
function! quickfix#close_empty() abort
    if len(getqflist())
        return
    endif
    for l:buffer in tabpagebuflist()
        if bufname(l:buffer) ==? ''
            cclose
            return
        endif
    endfor
endfunction

" Return 1 if quickfix window is open, else 0
function! quickfix#is_open() abort
    for l:buffer in tabpagebuflist()
        if bufname(l:buffer) ==? ''
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

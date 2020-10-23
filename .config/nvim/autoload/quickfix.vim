" Quickfix window functions
" Toggle quickfix window
let s:quickfix_size = 20

" Show :scriptnames in quickfix list and optionally filter
function quickfix#scriptnames(...)
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
function s:qf_toggle(size, ...)
    let l:mode = (a:0 == 0)? 2 : (a:1)
    function s:window_check(mode)
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

function quickfix#toggle()
    let l:qf_lines = len(getqflist())
    let l:qf_size = min([max([1, l:qf_lines]), get(g:, 'quickfix_size', s:quickfix_size)])
    call s:qf_toggle(l:qf_size)
endfunction

function quickfix#open()
    let l:qf_lines = len(getqflist())
    let l:qf_size = min([max([1, l:qf_lines]), get(g:, 'quickfix_size', s:quickfix_size)])
    execute 'copen' l:qf_size
    wincmd k
endfunction

" Close an empty quickfix window
function quickfix#close_empty()
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
function quickfix#is_open()
    for l:buffer in tabpagebuflist()
        if bufname(l:buffer) ==? ''
            return 1
        endif
    endfor
    return 0
endfunction

" Close quickfix on quit
" (Use autoclose script instead)
function quickfix#autoclose()
    if &filetype ==? 'qf'
        " if this window is last on screen quit without warning
        if winnr('$') < 2
            quit
        endif
    endif
endfunction

function s:isLocation()
    " Get dictionary of properties of the current window
    let wininfo = filter(getwininfo(), {i,v -> v.winnr == winnr()})[0]
    return wininfo.loclist
endfunction

function s:length()
    " Get the size of the current quickfix/location list
    return len(s:isLocation() ? getloclist(0) : getqflist())
endfunction

function s:getProperty(key, ...)
    " getqflist() and getloclist() expect a dictionary argument
    " If a 2nd argument has been passed in, use it as the value, else 0
    let l:what = {a:key : a:0 ? a:1 : 0}
    let l:listdict = s:isLocation() ? getloclist(0, l:what) : getqflist(l:what)
    return get(l:listdict, a:key)
endfunction

function s:isFirst()
    return s:getProperty('nr') <= 1
endfunction

function s:isLast()
    return s:getProperty("nr") == s:getProperty("nr", '$')
endfunction

function s:history(goNewer)
    " Build the command: one of colder/cnewer/lolder/lnewer
    let l:cmd = (s:isLocation() ? 'l' : 'c') . (a:goNewer ? 'newer' : 'older')

    " Apply the cmd repeatedly until we hit a non-empty list, or first/last list
    " is reached
    while 1
        if (a:goNewer && s:isLast()) || (!a:goNewer && s:isFirst()) | break | endif
        " Run the command. Use :silent to suppress message-history output.
        " Note that the :try wrapper is no longer necessary
        silent execute l:cmd
        if s:length() | break | endif
    endwhile

    " Set the height of the quickfix window to the size of the list, max-height 10
    execute 'resize' min([ 10, max([ 1, s:length() ]) ])

    " Echo a description of the new quickfix / location list.
    " And make it look like a rainbow.
    let l:nr = s:getProperty('nr')
    let l:last = s:getProperty('nr', '$')
    echohl MoreMsg | echon '('
    echohl Identifier | echon l:nr
    if l:last > 1
        echohl LineNr | echon ' of '
        echohl Identifier | echon l:last
    endif
    echohl MoreMsg | echon ') '
    echohl MoreMsg | echon '['
    echohl Identifier | echon s:length()
    echohl MoreMsg | echon '] '
    echohl Normal | echon s:getProperty('title')
    echohl None
endfunction

function quickfix#older()
    call s:history(0)
endfunction

function quickfix#newer()
    call s:history(1)
endfunction

function quickfix#move(direction, prefix)
    if a:direction ==# 'up'
        try
            execute a:prefix . "previous"
        catch /^Vim\%((\a\+)\)\=:E553/
            execute a:prefix . "last"
        catch /^Vim\%((\a\+)\)\=:E\%(325\|776\|42\):/
        endtry
    else
        try
            execute a:prefix . "next"
        catch /^Vim\%((\a\+)\)\=:E553/
            execute a:prefix . "first"
        catch /^Vim\%((\a\+)\)\=:E\%(325\|776\|42\):/
        endtry
    endif

    if &foldopen =~ 'quickfix' && foldclosed(line('.')) != -1
        normal! zv
    endif
endfunction

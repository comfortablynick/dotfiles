" Quickfix window functions
" Toggle quickfix window
let s:quickfix_size = 20
let s:qf_size = {lines -> min([max([1, lines]), get(g:, 'quickfix_size', s:quickfix_size)])}
let s:is_loc_open = {-> get(getloclist(0, {'winid':0}), 'winid', 0)}

" Show :scriptnames in quickfix list and optionally filter
function qf#scriptnames(...)
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
    endfunction
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

" toggles the location window associated with the current window
" or whatever location window has the focus
function qf#loc_toggle(stay, ...)
    " save the view if the current window is not a location window
    if get(g:, 'qf_save_win_view', 1) && !qf#is_loc()
        let l:winview = winsaveview()
    else
        let l:winview = {}
    endif

    if s:is_loc_open()
        lclose
        if !empty(l:winview)
            call winrestview(l:winview)
        endif
    else
        let l:size = get(a:, 1, s:quickfix_size)
        execute 'silent! lwindow' l:size
        if s:is_loc_open()
            wincmd p
            if !empty(l:winview)
                call winrestview(l:winview)
            endif
            if !a:stay
                wincmd p
            endif
        endif
    endif
endfunction

" Old func
" function qf#toggle()
"     let l:qf_lines = len(getqflist())
"     let l:qf_size = min([max([1, l:qf_lines]), get(g:, 'quickfix_size', s:quickfix_size)])
"     call s:qf_toggle(l:qf_size)
" endfunction

" Toggle quickfix list or, if empty, toggle existing loclist for this window
function qf#toggle()
    let l:qflist = getqflist()
    let l:loclist = []
    let l:is_loc = 0
    if len(l:qflist) == 0
        let l:loclist = getloclist(0)
        if len(l:loclist) > 0
            let l:is_loc = 1
        endif
    endif
    let l:list = l:is_loc ? l:loclist : l:qflist
    let l:lines = len(l:list)
    let l:qf_size = s:qf_size(l:lines)
    if l:is_loc
        call qf#loc_toggle(0, l:qf_size)
    else
        call s:qf_toggle(l:qf_size)
    end
endfunction

" Open qf window and move back to current window if `stay`
"
" Optional param object:
"   `stay` Don't move to qf window
"   `size` Size that overrides any other setting
function qf#open(...) abort
    let l:config = get(a:, 1, {})
    if type(l:config) isnot# v:t_dict | echoerr 'param must be a dict' | return | endif
    let l:qf_lines = len(getqflist())
    let l:qf_size = min([max([1, len(getqflist())]), get(g:, 'quickfix_size', s:quickfix_size)])
    let l:size = get(l:config, 'size')
    execute 'copen' l:size > 0 ? l:size : l:qf_size
    if get(l:config, 'stay', v:true) | wincmd p | endif
endfunction

" Close an empty quickfix window
function qf#close_empty()
    " if len(getqflist())
    "     return
    " endif
    " for l:buffer in tabpagebuflist()
    "     if bufname(l:buffer) ==? ''
    "         cclose
    "         return
    "     endif
    " endfor
    if len(getqflist()) == 0
        cclose
    end
endfunction

" Return 1 if quickfix window is open, else 0
function qf#is_open()
    let l:open_wins = get(gettabinfo(tabpagenr())[0], 'windows', {})
    let l:qf_wins = filter(l:open_wins, {_, v->getwininfo(v)[0].quickfix == 1})
    return len(l:qf_wins) != 0
endfunction

" Close quickfix on quit
" (Use autoclose script instead)
function qf#autoclose()
    if &filetype ==? 'qf'
        " if this window is last on screen quit without warning
        if winnr('$') < 2
            quit
        endif
    endif
endfunction

" let l:open_wins = get(gettabinfo(tabpagenr())[0], 'windows', {})

function qf#is_loc(...)
    let l:winnr = get(a:, 1, 0)
    let l:winnr = l:winnr == 0 ? winnr() : l:winnr
    let l:wininfo = getwininfo(win_getid(l:winnr))[0]
    return l:wininfo.loclist
endfunction

function s:isLocation()
    " Get dictionary of properties of the current window
    let l:wininfo = filter(getwininfo(), {_,v -> v.winnr == winnr()})[0]
    return l:wininfo.loclist
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
    return s:getProperty('nr') == s:getProperty('nr', '$')
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

function qf#older()
    call s:history(0)
endfunction

function qf#newer()
    call s:history(1)
endfunction

function qf#move(direction, prefix)
    if a:direction ==# 'up'
        try
            execute a:prefix 'previous'
        catch /^Vim\%((\a\+)\)\=:E553/
            execute a:prefix 'last'
        catch /^Vim\%((\a\+)\)\=:E\%(325\|776\|42\):/
        endtry
    else
        try
            execute a:prefix 'next'
        catch /^Vim\%((\a\+)\)\=:E553/
            execute a:prefix 'first'
        catch /^Vim\%((\a\+)\)\=:E\%(325\|776\|42\):/
        endtry
    endif

    if &foldopen =~# 'quickfix' && foldclosed(line('.')) != -1
        normal! zv
    endif
endfunction

" Removes current entry from current qf/loclist
function qf#remove_current_entry()
    let l:index = line('.') - 1
    let l:is_loc = qf#is_loc()
    let l:list = l:is_loc ? getloclist(0) : getqflist()
    call remove(l:list, l:index)
    if l:is_loc
        call setloclist(0, l:list, 'r')
    else
        call setqflist(l:list, 'r')
    endif
endfunction

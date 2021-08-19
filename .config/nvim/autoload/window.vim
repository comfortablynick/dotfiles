scriptencoding utf-8

" Get usable width of window
" Adapted from https://stackoverflow.com/a/52921337/10370751
function window#width() "{{{1
    let l:width = winwidth(0)
    let l:numberwidth = max([&numberwidth, strlen(line('$')) + 1])
    let l:numwidth = (&number || &relativenumber) ? l:numberwidth : 0
    let l:foldwidth = &foldcolumn
    let l:signwidth = 0

    if &signcolumn ==# 'yes'
        let l:signwidth = 2
    elseif &signcolumn ==# 'auto'
        let l:signs = execute('sign place buffer='.bufnr(''))
        let l:signs = split(l:signs, "\n")
        let l:signwidth = len(l:signs) > 2 ? 2 : 0
    endif
    return l:width - l:numwidth - l:foldwidth - l:signwidth
endfunction

" Create scratch window (accepts mods)
function window#open_scratch(mods, cmd) "{{{1
    if a:cmd ==# ''
        let l:output = ''
    elseif a:cmd[0] == '@'
        if strlen(a:cmd) ==# 2
            let l:output = getreg(a:cmd[1], 1, v:true)
        else
            throw 'Invalid register'
        endif
    elseif a:cmd[0] ==# '!'
        let l:cmd = a:cmd =~' %' ? substitute(a:cmd, ' %', ' ' . expand('%:p'), '') : a:cmd
        let l:output = systemlist(matchstr(l:cmd, '^!\zs.*'))
    else
        let l:output = split(execute(a:cmd), "\n")
    endif

    execute a:mods 'new'
    Scratchify
    call setline(1, l:output)
endfunction

" Close all terminal windows in current tabpage and vim-tmux-runner panes
function window#close_term() "{{{1
    " Kill vtr panes, if any
    " TODO: is there a way to do this only with the pane attached to window?
    silent! VtrKillRunner
    let l:wininfo = filter(getwininfo(), {_,v -> v.tabnr == tabpagenr() && v.terminal == 1})
    if empty(l:wininfo) | return | endif
    for l:win in l:wininfo
        execute l:win.winnr..'quit'
    endfor
endfunction

function window#tab_mod(cmd, ft) " Show cmd in new or existing tab {{{1
    " Reuse open tab if filetype matches `ft`
    " Adapted from https://github.com/airblade/vim-helptab
    let l:cmdtabnr = 0
    for l:i in range(tabpagenr('$'))
        let l:tabnr = l:i + 1
        for l:bufnr in tabpagebuflist(l:tabnr)
            if getbufvar(l:bufnr, '&ft') ==# a:ft
                let l:cmdtabnr = l:tabnr
                break
            endif
        endfor
    endfor
    if l:cmdtabnr
        if tabpagenr() == l:cmdtabnr
            return a:cmd
        else
            return 'tabnext '.l:cmdtabnr.' | '.a:cmd
        endif
    else
        return 'tab '.a:cmd
    endif
endfunction

" Vim-tmux-resize {{{1
" Simplified version of github.com/RyanMillerC/better-vim-tmux-resizer
" Maps <M-h/j/k/l> to resize vim splits in the given direction.
" If the movement operation has no effect in Vim, it forwards the operation to
" Tmux.
let g:tmux_resizer_resize_count = get(g:, 'tmux_resizer_resize_count', 5)
let g:tmux_resizer_vertical_resize_count = get(g:, 'tmux_resizer_vertical_resize_count', 10)

let s:tmux_socket = split($TMUX, ',')[0]

function s:TmuxCommand(args)
    let l:cmd = printf('tmux -S %s %s', s:tmux_socket, a:args)
    return system(l:cmd)
endfunction

function window#vim_resize(direction) "{{{2
    " Prevent resizing Vim upward when there is only a single window
    let l:layout = winlayout()
    " TODO: parsing `winlayout()` should be the best way
    if a:direction ==# 'j' && l:layout[0] ==# 'leaf'
        return
    endif

    " Prevent resizing Vim upward when down is pressed with all vsplit windows
    if a:direction ==# 'k'
        let l:all_windows_are_vsplit = v:true
        for l:window in range(1, winnr('$'))
            if win_screenpos(l:window)[0] != 1  " TODO: can be 2 if tabline
                let l:all_windows_are_vsplit = v:false
            endif
        endfor
        if l:all_windows_are_vsplit
            return
        endif
    endif

    " Resize Vim window toward given direction, like tmux
    let l:current_window_is_last_window = winnr() == winnr('$')
    if a:direction ==# 'h' || a:direction ==# 'k'
        let l:modifier = l:current_window_is_last_window ? '+' : '-'
    else
        let l:modifier = l:current_window_is_last_window ? '-' : '+'
    endif

    if a:direction ==# 'h' || a:direction ==# 'l'
        let l:command = 'vertical resize'
        let l:window_resize_count = g:tmux_resizer_vertical_resize_count
    else
        let l:command = 'resize'
        let l:window_resize_count = g:tmux_resizer_resize_count
    endif

    execute l:command l:modifier..l:window_resize_count
endfunction

function window#tmux_aware_resize(direction) "{{{2
    let l:previous_window_width = winwidth(0)
    let l:previous_window_height = winheight(0)

    " Attempt to resize Vim window
    call window#vim_resize(a:direction)

    " Call tmux if in session and vim window dimentions did not change
    if l:previous_window_height == winheight(0) && l:previous_window_width == winwidth(0) && !empty(s:tmux_socket)
        if a:direction ==# 'h' || a:direction ==# 'l'
            let l:resize_count = g:tmux_resizer_vertical_resize_count
        else
            let l:resize_count = g:tmux_resizer_resize_count
        endif
        let l:args = 'resize-pane -'..tr(a:direction, 'hjkl', 'LDUR')..' '..l:resize_count
        call s:TmuxCommand(l:args)
    endif
endfunction

function autoclose#next_normal_window()
    for l:i in range(1, winnr('$'))
        let l:buf = winbufnr(l:i)
        " skip unlisted buffers
        if !buflisted(l:buf) | continue | endif
        " skip temporary buffers with buftype set
        if getbufvar(l:buf, '&buftype') !=? '' | continue | endif
        " skip the preview window
        if getwinvar(l:i, '&previewwindow') | continue | endif
        " skip current window
        if l:i == winnr() | continue | endif
        return l:i
    endfor
    return -1
endfunction

function autoclose#quit_if_only_window()
    let l:bufnr = bufnr('')
    let l:buftype = getbufvar(l:bufnr, '&buftype')
    let l:filetype = getbufvar(l:bufnr, '&filetype')
    let g:autoclose_filetypes = get(g:, 'autoclose_filetypes', ['help', 'qf'])
    " if index(get(g:, 'autoclose_buftypes', []), l:buftype) < 0
    "     \ && index(get(g:, 'autoclose_filetypes', []), l:filetype) < 0
    "     return
    " endif
    if index(g:autoclose_filetypes, l:filetype) < 0 | return | endif

    " " Check if there is more than one window
    " if autoclose#next_normal_window() == -1
    "     " Check if there is more than one tab page
    "     if tabpagenr('$') == 1
    "         " Before quitting Vim, delete the special buffer so that
    "         " the '0 mark is correctly set to the previous buffer.
    "         " Also disable autocmd on this command to avoid unnecessary
    "         " autocmd nesting.
    "         if winnr('$') == 1 | noautocmd bdelete | endif
    "         quit
    "     else
    "         " Note: workaround for the fact that in new tab the buftype is set
    "         " too late (and sticks during this WinEntry autocmd to the old -
    "         " potentially quickfix/help buftype - that would automatically
    "         " close the new tab and open the buffer in copen window instead
    "         " New tabpage has previous window set to 0
    "         if tabpagewinnr(tabpagenr(), '#') != 0
    "             let l:last_window = 0
    "             if winnr('$') == 1 | let l:last_window = 1 | endif
    "             close
    "             if l:last_window == 1
    "                 " Note: workaround for the same bug, but w.r.t. Airline
    "                 " plugin (it needs to refresh buftype and status line after
    "                 " last special window autocmd close on a tab page
    "                 if exists(':AirlineRefresh') | execute 'AirlineRefresh' | endif
    "             endif
    "         endif
    "     endif
    " endif
endfunction

" Restore cursor position and folding
function! cursor#recall_last_position() abort
    " Derived from and simplified:
    " https://github.com/farmergreg/vim-lastplace/blob/master/plugin/vim-lastplace.vim

    " Options
    let open_folds = 1

    " Folds flicker and close anyway when using Coc
    if exists('g:did_coc_loaded')
        let open_folds = 0
    endif
    let ignore_buftype = [
        \ 'quickfix',
        \ 'nofile',
        \ 'help',
        \ ]
    let ignore_filetype = [
        \ 'gitcommit',
        \ 'gitrebase',
        \ 'svn',
        \ 'hgcommit',
        \ ]

    " Check filetype and buftype against ignore lists
    if index(ignore_buftype, &buftype) != -1 ||
        \ index(ignore_filetype, &filetype) != -1
        return
    endif

    " Do nothing if file does not exist on disk
    try
        if empty(glob(@%))
            return
        endif
    catch
        return
    endtry

    let lastpos = line("'\"")
    let buffend = line('$')
    let winend = line('w$')
    let winstart = line('w0')

    if lastpos > 0 && lastpos <= line('$')
        " Last edit pos is set and is < no of lines in buffer
        if winend == buffend
            " Last line in buffer is also last line visible
            execute 'normal! g`"'
        elseif buffend - lastpos > ((winend - winstart) / 2) - 1
            " Center cursor on screen if not at bottom
            execute 'normal! g`"zz'
        else
            " Otherwise, show as much context as we can
            execute "normal! \G'\"\<c-e>"
        endif
    endif

    if foldclosed('.') != -1 && open_folds
        " Cursor was inside a fold; open it
        execute 'normal! zv'
    endif
endfunction
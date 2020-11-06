" Remember last place in file
augroup plugin_buffer
    autocmd!
    autocmd BufWinEnter * call s:recall_cursor_position()
    " Execute `direnv allow` after editing .envrc
    autocmd BufWritePost .envrc if executable('direnv') | silent !direnv allow % | endif
augroup end

function! s:recall_cursor_position()
    " Derived from and simplified:
    " https://github.com/farmergreg/vim-lastplace/blob/master/plugin/vim-lastplace.vim

    " Options
    let l:open_folds = 1

    " Folds flicker and close anyway when using Coc
    if exists('g:did_coc_loaded')
        let l:open_folds = 0
    endif
    let l:ignore_buftype = [
        \ 'quickfix',
        \ 'nofile',
        \ 'help',
        \ ]
    let l:ignore_filetype = [
        \ 'gitcommit',
        \ 'gitrebase',
        \ 'svn',
        \ 'hgcommit',
        \ ]

    " Check filetype and buftype against ignore lists
    if index(l:ignore_buftype, &buftype) != -1 ||
        \ index(l:ignore_filetype, &filetype) != -1
        return
    endif

    " Do nothing if file does not exist on disk
    try
        if empty(glob(@%)) | return | endif
    catch
        return
    endtry

    let l:lastpos = line("'\"")
    let l:buffend = line('$')
    let l:winend = line('w$')
    let l:winstart = line('w0')

    if l:lastpos > 0 && l:lastpos <= l:buffend
        " Last edit pos is set and is < no of lines in buffer
        if l:winend == l:buffend
            " Last line in buffer is also last line visible
            execute 'normal! g`"'
        elseif l:buffend - l:lastpos > ((l:winend - l:winstart) / 2) - 1
            " Center cursor on screen if not at bottom
            execute 'normal! g`"zz'
        else
            " Otherwise, show as much context as we can
            execute "normal! \G'\"\<c-e>"
        endif
    endif

    if foldclosed('.') != -1 && l:open_folds
        " Cursor was inside a fold; open it
        execute 'normal! zv'
    endif
endfunction

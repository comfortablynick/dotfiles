" ====================================================
" Filename:    autoload/editor.vim
" Description: General editor behavior functions
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-03
" ====================================================

" Restore cursor position and folding
function! editor#recall_cursor_position() abort
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
        if empty(glob(@%)) | return | endif
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

" get_usuable_width() :: get actual usable width of current buffer
function! editor#get_usuable_width()
    " let width = winwidth(0)
    " let numberwidth = max([&numberwidth, strlen(line('$'))+1])
    " let numwidth = (&number || &relativenumber)? numberwidth : 0
    " let foldwidth = &foldcolumn
    "
    " if &signcolumn ==? 'yes'
    "     let signwidth = 2
    " elseif &signcolumn ==? 'auto'
    "     let signs = execute(printf('sign place buffer=%d', bufnr('')))
    "     let signs = split(signs, "\n")
    "     let signwidth = len(signs)>2? 2: 0
    " else
    "     let signwidth = 0
    " endif
    " return width - numwidth - foldwidth - signwidth
    lua require('floating').get_usable_width(0)
endfunction

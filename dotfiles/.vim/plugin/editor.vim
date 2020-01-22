" ====================================================
" Filename:    plugin/editor.vim
" Description: Editor behavior settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-21 18:05:28 CST
" ====================================================
if exists('g:loaded_editor_vim_rrxslb6k') | finish | endif
let g:loaded_editor_vim_rrxslb6k = 1

" Save if file has changed and reload vimrc
command! S update | source $MYVIMRC
" Lazy load startuptime.vim plugin
command! -nargs=* -complete=file StartupTime
    \ packadd startuptime.vim | StartupTime <args>

augroup editor_vim_rrxslb6k
    autocmd!
    " Cursor configuration
    " Remember last place in file
    autocmd BufWinEnter * call s:recall_cursor_position()

    " Set cursorline depending on mode, if cursorline is enabled in vimrc
    if &cursorline
        autocmd WinEnter,InsertLeave * set cursorline
        autocmd WinLeave,InsertEnter * set nocursorline
    endif

    " Toggle to number mode depending on vim mode
    " INSERT:       Turn off relativenumber while writing code
    " NORMAL:       Turn on relativenumber for easy navigation
    " NO FOCUS:     Turn off relativenumber (testing code, etc.)
    " Terminal:     Turn off all numbering
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter *
        \ if &number | setlocal relativenumber   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   *
        \ if &number | setlocal norelativenumber | endif
    autocmd TermOpen * setlocal nonumber norelativenumber
augroup end

" Abbreviations
cnoreabbrev <expr> l editor#cabbr('l', 'lua')
cnoreabbrev <expr> lp
    \ editor#cabbr('lp', 'lua p()<Left><C-R>=editor#eatchar(''\s'')<CR>')

" Restore cursor position and folding
function! s:recall_cursor_position() abort "{{{1
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

    if lastpos > 0 && lastpos <= buffend
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

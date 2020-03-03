" ====================================================
" Filename:    plugin/editor.vim
" Description: Editor behavior settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-03-03 13:31:54 CST
" ====================================================
let s:guard = 'g:loaded_plugin_editor' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" # Maps
" Format paragraph and restore cursor position
nnoremap <silent> Q :call editor#restore_cursor_after('gqap')<CR>
" Format buffer and restore cursor position
nnoremap <silent> <Leader>ff :call editor#restore_cursor_after('gggqG')<CR>
" Indent buffer and restore cursor position
nnoremap <silent> <Leader>fi :call editor#restore_cursor_after('gg=G')<CR>

" # Abbreviations
cnoreabbrev <expr> h <SID>help_tab()
cnoreabbrev <expr> l util#cabbr('l', 'lua')
cnoreabbrev <expr> lp
    \ util#cabbr('lp', 'lua p()<Left><C-R>=util#eatchar(''\s'')<CR>')

inoreabbrev <expr> fff editor#foldmarker()

" Call editor#help_tab() if ':h'
function! s:help_tab() abort
    if !(getcmdtype() == ':' && getcmdpos() <= 2)
        return 'h'
    endif
    return editor#help_tab()
endfunction


" # Autocmds
augroup plugin_editor
    autocmd!
    " Remember last place in file
    autocmd BufWinEnter * call s:recall_cursor_position()

    " Close certain read-only filetypes with only 'q'
    " Not likely to be using macros in these files
    autocmd FileType netrw,help,fugitive,qf
        \ nnoremap <silent><buffer> q :call editor#quick_close_buffer()<CR>

    " Terminal starts in insert mode
    autocmd TermOpen * :startinsert
    autocmd TermOpen * tnoremap <buffer><silent> <Esc> <C-\><C-n><CR>:bw!<CR>

    " Set cursorline depending on mode, if cursorline is enabled locally
    if &l:cursorline
        autocmd WinEnter,InsertLeave * set cursorline
        autocmd WinLeave,InsertEnter * set nocursorline
    endif

    " Toggle &(relative)number
    autocmd TermOpen * setlocal nonumber norelativenumber
    " Toggle relativenumber depending on mode and focus
    autocmd FocusGained,WinEnter,BufEnter *
        \ if &l:number | setlocal relativenumber | endif
    autocmd FocusLost,WinLeave,BufLeave *
        \ if &l:number | setlocal norelativenumber | endif
augroup end

" Restore cursor position and folding
function! s:recall_cursor_position() abort "{{{1
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

    if foldclosed('.') != -1 && l:open_folds
        " Cursor was inside a fold; open it
        execute 'normal! zv'
    endif
endfunction

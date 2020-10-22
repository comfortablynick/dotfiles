" Maps {{{1
" Format buffer and restore cursor position {{{2
nnoremap <silent> <Leader>ff :call editor#restore_cursor_after('gggqG')<CR>
" Indent buffer and restore cursor position {{{2
nnoremap <silent> <Leader>fi :call editor#restore_cursor_after('gg=G')<CR>

" Abbreviations {{{1
" Open help[grep] in new or existing tab {{{2
cnoreabbrev <expr> h
    \ map#cabbr('h', {->window#tab_mod('help', 'help')})
cnoreabbrev <expr> hg
    \ map#cabbr('hg', {->window#tab_mod('helpgrep', 'help')})

" Open help in vert split {{{2
call map#set_cabbr('vh', 'vert help')

" Open Man in new or existing tab {{{2
cnoreabbrev <expr> man
    \ map#cabbr('man', {->window#tab_mod('Man', 'man')})

" Lua {{{2
call map#set_cabbr('l', 'lua')
cnoreabbrev <expr> lp
    \ map#cabbr('lp', 'lua p()<Left><C-R>=map#eatchar(''\s'')<CR>')

" Fold marker {{{2
inoreabbrev fff <C-R>=editor#foldmarker()<CR><C-R>=map#eatchar('\s')<CR>

" Autocmds {{{1
augroup plugin_editor
    autocmd!
    " Remember last place in file {{{2
    autocmd BufWinEnter * call s:recall_cursor_position()
    " Close certain read-only filetypes with only 'q' {{{2
    " Not likely to be using macros in these files
    autocmd FileType netrw,help,fugitive,qf
        \ nnoremap <silent><buffer> q :call editor#quick_close_buffer()<CR>
    " Neovim terminal {{{2
    if has('nvim')
        " Terminal starts in insert mode
        autocmd TermOpen * startinsert
        " Toggle &(relative)number
        autocmd TermOpen * setlocal nonumber norelativenumber
        " autocmd TermOpen * tnoremap <buffer><silent> <Esc> <C-\><C-n><CR>:bw!<CR>
        autocmd TermClose * call feedkeys("\<C-\>\<C-n>")
        " Neovim yank highlight {{{2
        autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=500}
    endif
    " Set cursorline depending on mode, if cursorline is enabled locally {{{2
    if &l:cursorline
        autocmd WinEnter,InsertLeave * set cursorline
        autocmd WinLeave,InsertEnter * set nocursorline
    endif
    " Execute `direnv allow` after editing .envrc {{{2
    autocmd BufWritePost .envrc if executable('direnv') | silent !direnv allow % | endif
augroup end

augroup number_toggle
    autocmd!
    " Toggle relativenumber depending on mode and focus {{{2
    autocmd FocusGained,WinEnter,BufEnter,InsertLeave *
        \ if &l:number && empty(&buftype) | setlocal relativenumber | endif
    autocmd FocusLost,WinLeave,BufLeave,InsertEnter *
        \ if &l:number && empty(&buftype) | setlocal norelativenumber | endif
    " Easier exit from cmdwin {{{2
    autocmd CmdwinEnter * call s:cmdwin_enter()
augroup END

" Functions {{{1
function! s:cmdwin_enter() abort "{{{2
    nnoremap <buffer> <Leader>q <C-c><C-c>
    nnoremap <buffer> <Esc> <C-c><C-c>
    setlocal norelativenumber nonumber
endfunction

function! s:recall_cursor_position() abort "{{{2
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

" vim:fdl=1:

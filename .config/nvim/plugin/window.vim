" Window settings
augroup plugin_window
    autocmd!
    " Neovim terminal
    if has('nvim')
        " Terminal starts in insert mode
        autocmd TermOpen     * call s:on_termopen()
        autocmd TermClose    * call feedkeys("\<C-\>\<C-n>")
        autocmd ColorScheme  * call s:set_hl()
        autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="Yank", timeout=750}
    endif

    " Set cursorline depending on mode, if cursorline is enabled locally
    if &l:cursorline
        autocmd WinEnter,InsertLeave * set cursorline
        autocmd WinLeave,InsertEnter * set nocursorline
    endif

    " Toggle relativenumber depending on mode and focus, if relativenumber is enabled
    if &l:relativenumber
        autocmd FocusGained,WinEnter,BufEnter,InsertLeave *
            \ if &l:number && empty(&buftype) | setlocal relativenumber | endif
        autocmd FocusLost,WinLeave,BufLeave,InsertEnter *
            \ if &l:number && empty(&buftype) | setlocal norelativenumber | endif
    endif
    " Easier exit from cmdwin
    autocmd CmdwinEnter * call s:on_cmdwin_enter()
    " autocmd QuitPre * call autoclose#quit_if_only_window()
augroup END

function s:on_termopen()
    " startinsert
    nnoremap <buffer> q <Cmd>Bdelete!<CR>
    setlocal nonumber norelativenumber
    setlocal nobuflisted
    setlocal signcolumn=no
endfunction

function s:on_cmdwin_enter()
    let l:exit_maps = ['<Leader>q', '<Esc>', 'cq']
    for l:lhs in l:exit_maps
        execute 'nnoremap <buffer>' l:lhs '<C-c><C-c>'
    endfor
    setlocal number
    setlocal norelativenumber
endfunction

function s:set_hl()
    highlight Yank cterm=reverse gui=reverse
    " highlight clear CursorLine
    " call syntax#derive('CursorLineNr', 'CursorLineNr', 'guifg=yellow', 'gui=none')
endfunction

call s:set_hl()

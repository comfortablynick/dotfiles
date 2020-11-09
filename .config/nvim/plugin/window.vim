" Window settings
augroup plugin_window
    autocmd!
    " Neovim terminal
    if has('nvim')
        " Terminal starts in insert mode
        autocmd TermOpen * call s:on_termopen()
        " autocmd TermOpen * tnoremap <buffer><silent> <Esc> <C-\><C-n><CR>:bw!<CR>
        autocmd TermClose * call feedkeys("\<C-\>\<C-n>")
        " Neovim yank highlight
        autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=500}
    endif

    " Set cursorline depending on mode, if cursorline is enabled locally
    if &l:cursorline
        autocmd WinEnter,InsertLeave * set cursorline
        autocmd WinLeave,InsertEnter * set nocursorline
    endif

    " Toggle relativenumber depending on mode and focus
    autocmd FocusGained,WinEnter,BufEnter,InsertLeave *
        \ if &l:number && empty(&buftype) | setlocal relativenumber | endif
    autocmd FocusLost,WinLeave,BufLeave,InsertEnter *
        \ if &l:number && empty(&buftype) | setlocal norelativenumber | endif
    " Easier exit from cmdwin
    autocmd CmdwinEnter * call s:on_cmdwin_enter()
augroup END

function s:on_termopen()
    startinsert
    setlocal nonumber norelativenumber
    setlocal nobuflisted
endfunction

function s:on_cmdwin_enter()
    nnoremap <buffer> <Leader>q <C-c><C-c>
    nnoremap <buffer> <Esc> <C-c><C-c>
    setlocal norelativenumber nonumber
endfunction

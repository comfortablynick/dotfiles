" Window settings

augroup plugin_window
    autocmd!
    " Terminal starts in insert mode
    autocmd TermOpen     * call s:on_termopen()
    autocmd TermClose    * call feedkeys("\<C-\>\<C-n>")
    " Highlight on yank
    " Looks best with color attribute gui=reverse
    autocmd TextYankPost * lua vim.highlight.on_yank{ higroup = "TermCursor", timeout=750 }

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
    autocmd QuitPre * if &l:filetype != 'qf' | silent! lclose | silent! cclose | endif
    autocmd QuitPre * silent call buffer#autoclose()
augroup END

function s:on_termopen()
    " startinsert
    " nnoremap <buffer> q <Cmd>Bdelete!<CR>
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

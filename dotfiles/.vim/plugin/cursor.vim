" Cursor-related configuration
if exists('g:loaded_cursor_vim')
    finish
endif
let g:loaded_cursor_vim = 1

" Remember last place in file
augroup cursor
    autocmd!
    autocmd BufWinEnter * call cursor#recall_last_position()
    " Set cursorline depending on mode, if cursorline is enabled in vimrc
    if &cursorline
        autocmd WinEnter,InsertLeave * set cursorline
        autocmd WinLeave,InsertEnter * set nocursorline
    endif
augroup end

" ====================================================
" Filename:    plugin/editor.vim
" Description: Editor behavior settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-11-26
" ====================================================
if exists('g:loaded_editor_vim_rrxslb6k') | finish | endif
let g:loaded_editor_vim_rrxslb6k = 1

augroup editor_vim_rrxslb6k
    autocmd!
    " Cursor configuration
    " Remember last place in file
    autocmd BufWinEnter * call editor#recall_cursor_position()

    " Set cursorline depending on mode, if cursorline is enabled in vimrc
    if &cursorline
        autocmd WinEnter,InsertLeave * set cursorline
        autocmd WinLeave,InsertEnter * set nocursorline
    endif

    " Toggle to number mode depending on vim mode
    " INSERT:       Turn off relativenumber while writing code
    " NORMAL:       Turn on relativenumber for easy navigation
    " NO FOCUS:     Turn off relativenumber (testing code, etc.)
    " QuickFix:     Turn off relativenumber (running code)
    " Terminal:     Turn off all numbering
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
    autocmd FileType qf if &nu | set nornu | endif
    autocmd TermOpen * setlocal nonumber norelativenumber
augroup end

"    __                  _   _                       _
"   / _|_   _ _ __   ___| |_(_) ___  _ __  _____   _(_)_ __ ___
"  | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __\ \ / / | '_ ` _ \
"  |  _| |_| | | | | (__| |_| | (_) | | | \__ \\ V /| | | | | | |
"  |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___(_)_/ |_|_| |_| |_|
"
" Functions {{{
" SetShebang() :: add shebang for new file {{{
function! SetShebang()
python3 << endpython

import vim
shebang = {
	'python':     '#!/usr/bin/env python3',
	'sh':         '#!/usr/bin/env sh',
	'javascript': '#!/usr/bin/env node',
	'lua':        '#!/usr/bin/env lua',
	'ruby':       '#!/usr/bin/env ruby',
	'perl':       '#!/usr/bin/env perl',
	'php':        '#!/usr/bin/env php',
    'fish':       '#!/usr/bin/env fish',
    'awk':        '#!/bin/awk -f',
}
if not vim.current.buffer[0].startswith('#!'):
	filetype = vim.eval('&filetype')
	if filetype in shebang:
		vim.current.buffer[0:0] = [ shebang[filetype] ]
endpython
endfunction
" }}}
" GetPath() :: get path of current file {{{
function! GetPath()
python3 << EOP

import vim

file_path = vim.eval("expand('%:p')")
print(file_path)
EOP
endfunction
" }}}
" SetExecutableBit() :: set file as executable by user {{{
function! SetExecutableBit()
python3 << EOP

import os
import stat
import vim

file_path = vim.eval("expand('%:p')")
st = os.stat(file_path)
old_perms = stat.filemode(st.st_mode)
os.chmod(file_path, st.st_mode | 0o111)
new_st = os.stat(file_path)
new_perms = stat.filemode(new_st.st_mode)

if old_perms == new_perms:
    print(f"File already executable: {old_perms}")
else:
    print(f"File now executable; changed from {old_perms} to {new_perms}")
EOP
endfunction
" }}}
" SetExecutable() :: set shebang and executable bit {{{
function! SetExecutable()
    call SetExecutableBit()
    call SetShebang()
endfunction
" }}}
" Run Python Code in Vim (DEPRECATED) {{{
" Bind Ctrl+b to save file if modified and execute python script in a buffer.
" nnoremap <silent> <C-b> :call SaveAndExecutePython()<CR>
" vnoremap <silent> <C-b> :<C-u>call SaveAndExecutePython()<CR>
" nnoremap <silent> <C-x> :call ClosePythonWindow()<CR>

" SaveAndExecutePython() :: save file and execute python in split vim {{{
function! SaveAndExecutePython() abort
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute 'update | edit'

    " get file path of current file
    let s:current_buffer_file_path = expand('%')

    let s:output_buffer_name = 'Python'
    let s:output_buffer_filetype = 'output'

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists('s:buf_nr') || !bufexists(s:buf_nr)
        silent execute 'botright vsplit new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute 'setlocal filetype=' . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""
    setlocal wrap
    setlocal textwidth=0

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    silent %delete _

    " add the console output
    silent execute '.!python3 ' . shellescape(s:current_buffer_file_path, 1)

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable

    " Return to previous (code) window
    silent execute 'wincmd p'
endfunction
" }}}
" ClosePythonWindow() :: close window opened for running python {{{
function! ClosePythonWindow() abort
    " Close Python window we opened
    if bufexists(s:buf_nr)
        let ui_window_number = bufwinnr(s:buf_nr)
        if ui_window_number != -1
            silent execute ui_window_number . 'close'
        endif
    endif

    " Return to original window
    silent execute 'wincmd p'
endfunction
" }}}
" }}}
" ToggleQf() :: toggle quickfix window {{{
function! ToggleQf() abort
    if exists('*asyncrun#quickfix_toggle')
        " AsyncRun is loaded; use this handy function
        " Open qf window of specific size in most elegant way
        let qf_size = get(g:, 'quickfix_size', 8)
        call asyncrun#quickfix_toggle(qf_size)
        return
    endif
    for buffer in tabpagebuflist()
        if bufname(buffer) ==? ''
          " then it should be the quickfix window
          cclose
          return
        endif
    endfor
    " Quickfix window not open, so open it
    copen
endfunction
nnoremap <silent> qf :call ToggleQf()<cr>
" }}}
" AutoCloseQfWin() :: close qf on quit {{{
function! AutoCloseQfWin() abort
    if &filetype ==? 'qf'
        " if this window is last on screen quit without warning
        if winnr('$') < 2
            quit
        endif
    endif
endfunction
" }}}
" RunCommand() :: run command asynchronously in tmux
function! RunCommand(cmd) abort
    let panes = system('tmux display-message -p "#{window_panes}"')
    if panes >= 2
        execute 'AsyncRun tmux send-keys -t 2 ' . a:cmd
    endif
endfunction
" }}}
" Autocommands {{{
" Jump to last cursor position {{{
" Jump to last position when reopening file
augroup cursor_position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif
augroup END

" }}}
" Set shebang on new files {{{
" augroup shebang
"     autocmd!
"     autocmd BufNewFile * call SetShebang()
" augroup END
" }}}
" Close quickfix window on Vim exit {{{
" Close buffer if quickfix window is last
augroup quickfix
    autocmd!
    autocmd BufEnter * call AutoCloseQfWin()
augroup END
" }}}
" Don't insert comment leader on 'o' {{{
augroup fmtopts
    autocmd!
    autocmd BufNewFile,BufRead * setlocal formatoptions-=o
augroup END
" }}}
" }}}
" vim:set fdl=1:

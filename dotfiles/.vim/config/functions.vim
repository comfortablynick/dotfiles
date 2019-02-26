" vim:set fdl=1:
"    __                  _   _                       _
"   / _|_   _ _ __   ___| |_(_) ___  _ __  _____   _(_)_ __ ___
"  | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __\ \ / / | '_ ` _ \
"  |  _| |_| | | | | (__| |_| | (_) | | | \__ \\ V /| | | | | | |
"  |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___(_)_/ |_|_| |_| |_|
"
" Functions {{{1
" File operations {{{2
" SetShebang() :: add shebang for new file {{{3
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
    'bash':       '#!/usr/bin/env bash',
    'zsh':        '#!/usr/bin/env zsh',
}
if not vim.current.buffer[0].startswith('#!'):
	filetype = vim.eval('&filetype')
	vim.current.buffer[0:0] = [ shebang.get(filetype, shebang['bash']) ]
endpython
endfunction

" GetPath() :: get path of current file {{{3
function! GetPath()
    return expand('%:p')
endfunction

" SetExecutableBit() :: set file as executable by user {{{3
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

" SetExecutable() :: set shebang and executable bit {{{3
function! SetExecutable()
    call SetExecutableBit()
    call SetShebang()
endfunction

" GetRootFolderName() :: get just the name of the folder {{{3
function! GetRootFolderName()

endfunction
" Run code {{{2
" Run Python Code in Vim (DEPRECATED) {{{3
" Bind Ctrl+b to save file if modified and execute python script in a buffer.
" nnoremap <silent> <C-b> :call SaveAndExecutePython()<CR>
" vnoremap <silent> <C-b> :<C-u>call SaveAndExecutePython()<CR>
" nnoremap <silent> <C-x> :call ClosePythonWindow()<CR>

" SaveAndExecutePython() :: save file and execute python in split vim {{{4
" function! SaveAndExecutePython() abort
"     " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim
"
"     " save and reload current file
"     silent execute 'update | edit'
"
"     " get file path of current file
"     let s:current_buffer_file_path = expand('%')
"
"     let s:output_buffer_name = 'Python'
"     let s:output_buffer_filetype = 'output'
"
"     " reuse existing buffer window if it exists otherwise create a new one
"     if !exists('s:buf_nr') || !bufexists(s:buf_nr)
"         silent execute 'botright vsplit new ' . s:output_buffer_name
"         let s:buf_nr = bufnr('%')
"     elseif bufwinnr(s:buf_nr) == -1
"         silent execute 'botright new'
"         silent execute s:buf_nr . 'buffer'
"     elseif bufwinnr(s:buf_nr) != bufwinnr('%')
"         silent execute bufwinnr(s:buf_nr) . 'wincmd w'
"     endif
"
"     silent execute 'setlocal filetype=' . s:output_buffer_filetype
"     setlocal bufhidden=delete
"     setlocal buftype=nofile
"     setlocal noswapfile
"     setlocal nobuflisted
"     setlocal winfixheight
"     setlocal cursorline " make it easy to distinguish
"     setlocal nonumber
"     setlocal norelativenumber
"     setlocal showbreak=""
"     setlocal wrap
"     setlocal textwidth=0
"
"     " clear the buffer
"     setlocal noreadonly
"     setlocal modifiable
"     silent %delete _
"
"     " add the console output
"     silent execute '.!python3 ' . shellescape(s:current_buffer_file_path, 1)
"
"     " make the buffer non modifiable
"     setlocal readonly
"     setlocal nomodifiable
"
"     " Return to previous (code) window
"     silent execute 'wincmd p'
" endfunction
"
" ClosePythonWindow() :: close window opened for running python {{{4
" function! ClosePythonWindow() abort
"     " Close Python window we opened
"     if bufexists(s:buf_nr)
"         let ui_window_number = bufwinnr(s:buf_nr)
"         if ui_window_number != -1
"             silent execute ui_window_number . 'close'
"         endif
"     endif
"
"     " Return to original window
"     silent execute 'wincmd p'
" endfunction


" Quickfix window {{{2
" ToggleQf() :: toggle quickfix window {{{3
function! ToggleQf() abort
    if exists('*asyncrun#quickfix_toggle')
        " AsyncRun is loaded; use this handy function
        " Open qf window of specific size in most elegant way
        let qf_lines = len(getqflist())
        let qf_size = qf_lines ?
            \ min([qf_lines, get(g:, 'quickfix_size', 12)]) :
            \ 1
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

" CloseEmptyQf() :: close an empty quickfix window {{{3
function! CloseEmptyQf() abort
    if len(getqflist())
        return
    endif
    for buffer in tabpagebuflist()
        if bufname(buffer) ==? ''
            call ToggleQf()
            return
        endif
    endfor
endfunction

" IsQfOpen() :: check if quickfix window is open {{{3
function! IsQfOpen() abort
    for buffer in tabpagebuflist()
        if bufname(buffer) ==? ''
            return 1
        endif
    endfor
    return 0
endfunction

" AutoCloseQfWin() :: close qf on quit {{{3
function! AutoCloseQfWin() abort
    if &filetype ==? 'qf'
        " if this window is last on screen quit without warning
        if winnr('$') < 2
            quit
        endif
    endif
endfunction

" Building {{{2
" RunBuild() :: build/install current project
function! RunBuild() abort
    " Run build plugins
    let s:ft_cmds = {
        \ 'go': {
        \   'cmd': 'AsyncRun go install',
        \   'show_qf': 0
        \  },
        \ 'cpp': {
        \   'cmd': 'AsyncRun -cwd=<root>/build make install',
        \   'show_qf': 1
        \  },
        \ 'rust': {
        \   'cmd': 'AsyncRun cargo build',
        \   'show_qf': 0
        \  },
        \ }
    let s:ft = get(s:ft_cmds, &filetype, {})
    let s:cmd = get(s:ft, 'cmd', '')
    let s:qf_size = get(s:ft, 'show_qf', 0) * g:asyncrun_open
    if s:cmd !=? ''
        if s:cmd =~# 'AsyncRun'
            let g:asyncrun_exit = 'call CheckRun("Build")'
            let g:asyncrun_open = s:qf_size
            execute s:cmd
            return
        endif
        " Regular command
        execute s:cmd
        return
    endif
endfunction

function! RunMakeInstall() abort
    execute 'AsyncRun -cwd=<root>/build make install'
endfunction
" AsyncRun {{{2
" CheckRun() :: check AsyncRun return code
function! CheckRun(cmdName) abort
   if g:asyncrun_status ==? 'success'
       echo a:cmdName . ' completed successfully'
       return
   endif
   if g:asyncrun_status ==? 'failure'
       if IsQfOpen() == 0
           call ToggleQf()
       endif
       echo a:cmdName . ' failed. Check quickfix for details'
       return
   endif
endfunction

" General {{{2
" RunCommand() :: run command asynchronously in tmux pane {{{3
function! RunCommand(cmd) abort
    let panes = system('tmux display-message -p "#{window_panes}"')
    if panes >= 2
        " Don't open quickfix window
        let g:asyncrun_auto = 0
        execute 'AsyncRun tmux send-keys -t 2 ' . a:cmd
    endif
endfunction

" OpenTagbar() :: wrapper for tagbar#autoopen with options {{{3
function! OpenTagbar() abort
    if winwidth(0) > 100
        call tagbar#autoopen(0)
    else
        return
    endif
endfunction

" LastPlace() :: restore cursor position and folding {{{3
function! LastPlace()
    " Derived from and simplified:
    " https://github.com/farmergreg/vim-lastplace/blob/master/plugin/vim-lastplace.vim

    " Options
    let open_folds = 1
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
        if empty(glob(@%))
            return
        endif
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

" BufWidth() :: get actual usable width of current buffer {{{3
function! BufWidth()
  let width = winwidth(0)
  let numberwidth = max([&numberwidth, strlen(line('$'))+1])
  let numwidth = (&number || &relativenumber)? numberwidth : 0
  let foldwidth = &foldcolumn

  if &signcolumn ==? 'yes'
    let signwidth = 2
  elseif &signcolumn ==? 'auto'
    let signs = execute(printf('sign place buffer=%d', bufnr('')))
    let signs = split(signs, "\n")
    let signwidth = len(signs)>2? 2: 0
  else
    let signwidth = 0
  endif
  return width - numwidth - foldwidth - signwidth
endfunction

" (Auto)commands {{{1
" Cursor position {{{2
augroup last_place
    autocmd!
    autocmd BufWinEnter * call LastPlace()
augroup END

" Vim Fugitive {{{2
" Use AsyncRun
if exists('*asyncrun#execute')
    command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
endif

" Quickfix window {{{2
augroup quickfix
    autocmd!
    " Close buffer if quickfix window is last
    autocmd BufEnter * call AutoCloseQfWin()
    " Push quickfix window always to the bottom
    autocmd FileType qf wincmd J
    " Close qf after lint if empty
    autocmd User ALELintPost call CloseEmptyQf()
augroup END

" Neoformat {{{2
augroup fmt
    autocmd!
    autocmd BufWritePre *.{bash,sh} Neoformat
augroup end

" Formatopts {{{2
augroup fmtopts
    autocmd!
    autocmd BufNewFile,BufRead * setlocal formatoptions-=o
augroup END

" Commands {{{1
" Sudo save {{{2
" Note: does not work in Neovim in some cases
" Use `sudo -E vim {file}` to open vim while preserving user environment
command W w !sudo tee "%" > /dev/null

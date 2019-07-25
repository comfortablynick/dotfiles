" Personal functions
" Add shebang for new file
function! nick#functions#set_shebang() abort
    python3 << EOP
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
    try:
        vim.current.buffer[0:0] = [ shebang[filetype] ]
    except KeyError:
        vim.err_write("No shebang for filetype '{}'\n".format(filetype))
EOP
endfunction

" Get path of current file
function! nick#functions#get_path() abort
    return expand('%:p')
endfunction

" Set file as executable by user
function! nick#functions#set_executable_bit() abort
    python3 << EOP
import os
import stat
import vim

file_path = vim.eval("expand('%:p')")
try:
    st = os.stat(file_path)
    old_perms = stat.filemode(st.st_mode)
    os.chmod(file_path, st.st_mode | 0o111)
    new_st = os.stat(file_path)
    new_perms = stat.filemode(new_st.st_mode)

    if old_perms == new_perms:
        print(f"File already executable: {old_perms}")
    else:
        print(f"File now executable; changed from {old_perms} to {new_perms}")
except FileNotFoundError:
    vim.err_write("Error setting executable bit: file must be saved to disk first.\n")
EOP
endfunction

" Set shebang and executable bit
function! nick#functions#set_executable() abort
    call nick#functions#set_executable_bit()
    call nick#functions#set_shebang()
endfunction

" Get character under cursor
function! nick#functions#get_cursor_char() abort
    return strcharpart(strpart(getline('.'), col('.') - 1), 0, 1)
endfunction

" Get syntax group of item under cursor
function! nick#functions#syn_group() abort
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" Return details of syntax highlight
function! nick#functions#extract_highlight(group, what, ...) abort
    if a:0 == 1
        return synIDattr(synIDtrans(hlID(a:group)), a:what, a:1)
    else
        return synIDattr(synIDtrans(hlID(a:group)), a:what)
    endif
endfunction

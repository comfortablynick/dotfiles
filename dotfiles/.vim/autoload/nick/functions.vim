
" Add shebang for new file
function! nick#functions#set_shebang() abort
    py3 << EOF
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
EOF
endfunction

" Get path of current file
function! nick#functions#get_path() abort
    return expand('%:p')
endfunction

" Set file as executable by user
function! nick#functions#set_executable_bit() abort
    py3 << EOF
import os
import stat
import vim

def main():
    file_path = vim.eval("expand('%:p')")
    try:
        st = os.stat(file_path)
    except FileNotFoundError:
        print(f"Error setting executable bit: file does not exist or has not been saved.")
        return
    old_perms = stat.filemode(st.st_mode)
    os.chmod(file_path, st.st_mode | 0o111)
    new_st = os.stat(file_path)
    new_perms = stat.filemode(new_st.st_mode)

    if old_perms == new_perms:
        print(f"File already executable: {old_perms}")
    else:
        print(f"File now executable; changed from {old_perms} to {new_perms}")

if __name__ == '__main__':
    main()
EOF
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
function! nick#functions#syn_group()
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

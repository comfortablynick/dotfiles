" ====================================================
" Filename:    autoload/file.vim
" Description: File/folder operations
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-04-27 13:44:45 CDT
" ====================================================

" Get the root path based on git or parent folder
function! file#get_project_root() abort
    " Check if this has already been defined
    if exists('b:project_root_dir')
        return b:project_root_dir
    endif
    packadd vim-rooter
    if exists('*FindRootDirectory')
        let l:root = FindRootDirectory()
    else
        " Get root from git or file parent dir
        let l:root = substitute(system('git rev-parse --show-toplevel'), '\n\+$', '', '')
        if ! isdirectory(l:root)
            let l:root = expand('%:p:h')
        endif
    endif
    " Save root in buffer local variable
    let b:project_root_dir = l:root
    return b:project_root_dir
endfunction

" Get just the name of the folder
function! file#get_root_folder_name() abort
    let l:root = file#get_project_root()
    return matchstr(l:root, '[^\/\\]*$')
endfunction

" Set vim cwd to project root dir
" (git project root or directory of current file if not git project)
function! file#set_project_root() abort
    let l:root_dir = file#get_project_root()
    lcd `=l:root_dir`
endfunction

" Add shebang for new file
function! file#set_shebang() abort
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
function! file#get_path() abort
    return expand('%:p')
endfunction

" Set file as executable by user
function! file#set_executable_bit() abort
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
function! file#set_executable() abort
    call file#set_executable_bit()
    call file#set_shebang()
endfunction

" Any files we don't want timestamps for
let g:timestamp_file_ignore = [
    \ 'gitcommit',
    \ ]

" Update timestamp within the 20 first lines; matches:
" Last [Cc]hange(d)
" Changed
" Last [Mm]odified
" Modified
" Last [Uu]pdate(d)
function! file#update_timestamp() abort
    if index(g:timestamp_file_ignore, &filetype) > -1 | return | endif
    let l:pat = '\(\(Last\)\?\s*\([Cc]hanged\?\|[Mm]odified\|[Uu]pdated\?\)\s*:\s*\).*'
    let l:rep = '\1' . strftime(get(g:, 'timestamp_format', '%F %H:%M:%S %Z'))
    call s:subst(1, 20, l:pat, l:rep)
endfunction

" subst( start, end, pat, rep): substitute on range start - end.
" Taken from timestamp.vim
function! s:subst(start, end, pat, rep) abort
    let l:lineno = a:start
    while l:lineno <= a:end
        let l:curline = getline(l:lineno)
        if match(l:curline, a:pat) != -1
            let l:newline = substitute(l:curline, a:pat, a:rep, '')
            if l:newline != l:curline
                " Only substitute if we made a change
                keepjumps call setline(l:lineno, l:newline)
            endif
        endif
        let l:lineno = l:lineno + 1
    endwhile
endfunction

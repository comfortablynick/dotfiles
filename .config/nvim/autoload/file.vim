" Get the root path based on git or parent folder
function file#get_project_root()
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
        if !isdirectory(l:root)
            let l:root = expand('%:p:h')
        endif
    endif
    " Save root in buffer local variable
    let b:project_root_dir = l:root
    return b:project_root_dir
endfunction

" Get just the name of the folder
function file#get_root_folder_name()
    let l:root = file#get_project_root()
    return matchstr(l:root, '[^\/\\]*$')
endfunction

" Set vim cwd to project root dir
" (git project root or directory of current file if not git project)
function file#set_project_root()
    let l:root_dir = file#get_project_root()
    lcd `=l:root_dir`
endfunction

" Return path components of current file relative to .vim directory
function file#relative_to_config()
    python3 <<
from pathlib import PurePath
import os
import re
path = vim.eval('expand("%:p:r")')
fp = PurePath(path)
relpath = fp.relative_to(os.path.expandvars("$VDOTDIR"))
relpath = relpath.parts
# relpath = os.path.split(relpath)
# relpath = [re.sub(r'[^A-Za-z0-9]+','_', r) for r in relpath]
.
    return py3eval('relpath')
endfunction

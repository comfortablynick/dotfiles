if exists('g:loaded_files_vim')
    finish
endif
let g:loaded_files_vim = 1


" Get the root path based on git or parent folder
function! files#get_project_root() abort
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
function! files#get_root_folder_name() abort
    let l:root = files#get_project_root()
    return matchstr(l:root, '[^\/\\]*$')
endfunction

" Set vim cwd to project root dir
" (git project root or directory of current file if not git project)
function! files#set_project_root() abort
    let l:root_dir = files#get_project_root()
    lcd `=l:root_dir`
endfunction

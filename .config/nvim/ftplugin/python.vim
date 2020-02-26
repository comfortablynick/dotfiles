let s:guard = 'g:loaded_ftplugin_python' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Settings for Python files

" PEP8 Compatibile Indenting
setlocal smartindent                        " Attempt smart indenting
setlocal autoindent                         " Attempt auto indenting
setlocal foldmethod=marker                  " Use 3x{ for folding
setlocal formatprg=black\ --quiet\ -        " Use black for formatting

" Other
let g:python_highlight_all=1                " Highlight all builtins
let $PYTHONUNBUFFERED=1                     " Disable stdout buffering

let g:semshi#mark_selected_nodes = 0
let g:semshi#error_sign = v:false

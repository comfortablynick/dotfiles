" Settings for Python files

" PEP8 Compatibile Indenting
setlocal expandtab                          " Expand tab to spaces
setlocal smartindent                        " Attempt smart indenting
setlocal autoindent                         " Attempt auto indenting
setlocal shiftwidth=4                       " Indent width in spaces
setlocal softtabstop=4
setlocal tabstop=4
setlocal foldmethod=marker                  " Use 3x{ for folding

" Other
setlocal backspace=2                        " Backspace behaves as expected
let python_highlight_all=1                  " Highlight all builtins
let $PYTHONUNBUFFERED=1                     " Disable stdout buffering


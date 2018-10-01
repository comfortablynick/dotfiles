" Settings for Python files

" PEP8 Compatibile Indenting
setlocal expandtab                   " Expand tab to spaces
setlocal smartindent                 " Attempt smart indenting
setlocal autoindent                  " Attempt auto indenting
setlocal shiftwidth=4                " Indent width in spaces
setlocal softtabstop=4
setlocal tabstop=4

" Other
setlocal backspace=2                 " Backspace behaves as expected

" Set shebang
autocmd BufNewFile * call SetShebang()

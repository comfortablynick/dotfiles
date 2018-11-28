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
let python_highlight_all=1           " Highlight all builtins

" Disable stdout buffering
let $PYTHONUNBUFFERED=1

" Map
" Execute current file with AsyncRun
if exists('*asyncrun#quickfix_toggle')
    nnoremap <silent> <C-b> :AsyncRun -raw python "$(VIM_FILEPATH)"<CR>
    nnoremap <silent> <C-x> :call ToggleQf()<CR>
else
    nnoremap <silent> <C-b> :call SaveAndExecutePython()<CR>
    nnoremap <silent> <C-x> :call ClosePythonWindow()<CR>
endif

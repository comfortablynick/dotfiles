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
    function! AsyncRun_Python_Cmd() abort
        let scroll = get(g:, 'quickfix_run_scroll', 1)
        let raw = get(g:, 'asyncrun_raw_output', 0)
        let cmd = scroll ? ':AsyncRun' : ':AsyncRun!'
        let raw_cmd = raw ? ' -raw' : ''
        return cmd . raw_cmd . ' python3 % <CR>'
    endfunction

    " Use $(VIM_FILEPATH) if full filepath needed
    execute 'nnoremap <silent> <C-b> ' . AsyncRun_Python_Cmd()
    nnoremap <silent> <C-x> :call ToggleQf()<CR>
else
    nnoremap <silent> <C-b> :call SaveAndExecutePython()<CR>
    nnoremap <silent> <C-x> :call ClosePythonWindow()<CR>
endif

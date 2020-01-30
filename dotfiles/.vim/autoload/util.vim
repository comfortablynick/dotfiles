if exists('g:loaded_autoload_util') | finish | endif
let g:loaded_autoload_util = 1

function! util#highlights() abort
    let l:hl = execute(':highlight')
    let l:qf = []
    for line in split(l:hl, '\n')
        call add(l:qf, line)
    endfor
    return l:qf
endfunction

function! util#capture_output(cmd) abort
    " Capture output of command and return as list
    if has('nvim')
        let out = execute(a:cmd)
    else
        " Do it the old way
        try
            redir => out
            execute 'silent!'.a:cmd
        finally
            redir END
        endtry
    endif
    return split(out, '\n')
endfunction

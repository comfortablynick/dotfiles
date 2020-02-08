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

" Capture output of command and return as list
function! util#capture(cmd) abort
    if a:cmd =~# '^!'
        " System command output
        let cmd = a:cmd =~# ' %' ? substitute(a:cmd, ' %', ' ' . expand('%:p'), '') : a:cmd
        let out = system(matchstr(cmd, '^!\zs.*'))
    else
        " Redirect of vim command
        if v:version < 800
            " Do it the old way
            try
                redir => out
                execute 'silent!'.a:cmd
            finally
                redir END
            endtry
        else
            let out = execute(a:cmd)
        endif
    endif
    return split(out, '\n')
endfunction

" Redirect output of command to scratch buffer
" Borrowed some from romainl:
" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! util#redir(cmd) abort
    for win in range(1, winnr('$'))
        if getwinvar(win, 'scratch')
            execute win . 'windo close'
        endif
    endfor
    if type(a:cmd) == v:t_list
        let lines = a:cmd
    else
        let lines = util#capture(a:cmd)
    endif
    vnew
    let w:scratch = 1
    setlocal buftype=nofile bufhidden=wipe nobuflisted
    setlocal readonly noswapfile foldlevel=99
    call setline(1, lines)
endfunction

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
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile foldlevel=99
    call setline(1, lines)
endfunction

" Convert :scriptnames into qf format
function! util#scriptnames() abort
    return map(
        \ map(util#capture('scriptnames'), { _, v -> split(v, "\\v:=\\s+")}),
        \ {_, v -> {'text': v[0], 'filename': expand(v[1])}}
        \ )
endfunction

" Pretty format using python3 pprint
function! util#pformat(args) abort
    let l:pp = ''
py3 <<EOF
import vim
from pprint import pformat
args = pformat(vim.eval('a:args'))
vim.command(f"let l:pp = {repr(args)}")
EOF
return l:pp
endfunction

" Expand cabbr if it's the only command
function! util#cabbr(lhs, rhs) abort
    if getcmdtype() ==# ':' && getcmdline() ==# a:lhs
        return a:rhs
    endif
    return a:lhs
endfunction

" Eat space (from h: abbr)
function! util#eatchar(pat) abort
    let l:c = nr2char(getchar(0))
    return (l:c =~ a:pat) ? '' : l:c
endfunc


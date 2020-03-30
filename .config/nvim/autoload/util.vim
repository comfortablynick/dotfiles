" ====================================================
" Filename:    autoload/util.vim
" Description: Utility functions
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_autoload_util' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" util#capture() :: Capture output of command and return as list {{{1
function! util#capture(cmd) abort
    if a:cmd =~# '^!'
        " System command output
        let l:cmd = a:cmd =~# ' %' ? substitute(a:cmd, ' %', ' ' . expand('%:p'), '') : a:cmd
        let l:out = system(matchstr(l:cmd, '^!\zs.*'))
    else
        " Redirect of vim command
        if v:version < 800
            " Do it the old way
            try
                redir => l:out
                execute 'silent!' a:cmd
            finally
                redir END
            endtry
        else
            let l:out = execute(a:cmd)
        endif
    endif
    return split(l:out, '\n')
endfunction

" util#redir() :: Redirect output of command to scratch buffer {{{1
" Borrowed some from romainl:
" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! util#redir(cmd) abort
    for l:win in range(1, winnr('$'))
        if getwinvar(l:win, 'scratch')
            execute l:win 'windo close'
        endif
    endfor
    if type(a:cmd) == v:t_list
        let l:lines = a:cmd
    else
        let l:lines = util#capture(a:cmd)
    endif
    vnew
    let w:scratch = 1
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile foldlevel=99
    call setline(1, l:lines)
endfunction

" util#scriptnames() :: Convert :scriptnames into qf format {{{1
function! util#scriptnames() abort
    return map(
        \ map(util#capture('scriptnames'), { _, v -> split(v, "\\v:=\\s+")}),
        \ {_, v -> {'text': v[0], 'filename': expand(v[1])}}
        \ )
endfunction

" util#pformat() :: Pretty format using python3 pprint {{{1
function! util#pformat(args) abort
py3 <<END
import vim
from pprint import pformat
args = pformat(vim.eval('a:args'))
END
    return py3eval('args')
endfunction

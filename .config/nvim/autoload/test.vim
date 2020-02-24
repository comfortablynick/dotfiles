" ====================================================
" Filename:    autoload/test.vim
" Description: Various test functions for viml
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-24 14:42:41 CST
" ====================================================

function! test#time(com, ...) abort
    let l:time = 0.0
    let l:iters = a:0 ? a:1 : 100
    let l:t = reltime()
    for l:i in range(l:iters + 1)
        execute a:com
        echo l:i.' / '.l:iters
        redraw
    endfor
    let l:elapsed = reltimefloat(reltime(l:t))
    echo printf('Elapsed time: %f sec Average: %f ms', l:elapsed, (l:elapsed/l:iters * 1000))
endfunction

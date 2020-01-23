" ====================================================
" Filename:    autoload/test.vim
" Description: Various test functions for viml
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-23 08:36:10 CST
" ====================================================

function! test#time(com, ...) abort
    let time = 0.0
    let iters = a:0 ? a:1 : 100
    let t = reltime()
    for i in range(iters + 1)
        execute a:com
        echo i.' / '.iters
        redraw
    endfor
    let elapsed = reltimefloat(reltime(t))
    echo printf('Elapsed time: %f sec Average: %f ms', elapsed, (elapsed/iters * 1000))
endfunction

function test#time(com, ...)
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

" Get <SID> for arbitrary scripts in &rtp
" Defaults to current file unless pattern is specified
function test#get_sid(...)
    if a:0 > 0
        let l:file = a:1
        execute 'runtime' l:file
    else
        let l:file = expand('%')
    endif
    return matchlist(execute('scriptnames'), '\([0-9]\+\): [^ ]*'..l:file)[1]
endfunction

function test#call_sfunc(func, ...)
    let l:sid = test#get_sid()
    execute 'call <SNR>'..l:sid..'_'..a:func..'()'
endfunction

function test#get_sfunc(func, ...)
    let l:sid = test#get_sid()
    return function('<SNR>'..l:sid..'_'..a:func, a:000)
endfunction

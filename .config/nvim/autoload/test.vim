function test#time(com, ...)
    let l:time = 0.0
    let l:iters = a:0 ? a:1 : 100
    let l:t = reltime()
    let l:i = 0
    while l:i < l:iters
        execute a:com
        let l:i += 1
    endwhile
    let l:elapsed = reltimefloat(reltime(l:t))
    echomsg printf('%s -- [elapsed: %f sec (count=%d)]',
        \ a:com,
        \ l:elapsed,
        \ l:i,
        \ )
endfunction

" Get <SID> for arbitrary scripts in &rtp
" Defaults to current file unless pattern is specified
function test#get_sid(...)
    let l:file = a:0 > 0 ? a:1 : expand('%')
    silent! execute 'runtime' l:file
    return filter(util#scriptnames(), {_,v -> v.filename =~# l:file})[0]['text']
endfunction

function test#call_sfunc(func, ...)
    let l:sid = test#get_sid()
    execute 'call <SNR>'..l:sid..'_'..a:func..'()'
endfunction

function test#get_sfunc(func, ...)
    let l:sid = test#get_sid()
    return function('<SNR>'..l:sid..'_'..a:func, a:000)
endfunction

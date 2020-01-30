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

" Clap provider similar to :Scriptnames in vim-scriptease
let s:scriptnames = {}

function! s:scriptnames.source()
    let l:names = execute('scriptnames')
    return map(split(l:names, '\n'), {_,v -> join(split(v, ':'))})
endfunction

function! s:scriptnames.sink(selected)
    let l:fname = split(a:selected, ' ')[-1]
    execute 'edit' trim(l:fname)
endfunction

function! s:scriptnames.on_move()
    let l:curline = g:clap.display.getcurline()
    let l:fname = split(l:curline, ' ')[-1]
    return clap#preview#file(l:fname)
endfunction

let s:scriptnames.syntax = 'clap_scriptnames'
let g:clap#provider#scriptnames# = s:scriptnames

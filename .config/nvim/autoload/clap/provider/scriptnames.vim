" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Show loaded scripts (like :Scriptnames in vim-scriptease)

let s:scriptnames = {}

function s:into_filename(sel) abort
    return matchstr(a:sel, '\S*$')
endfunction

function s:scriptnames.source() abort
    let l:names = execute('scriptnames')
    return map(split(l:names, '\n'), {_,v -> join(split(v, ':'))})
endfunction

function s:scriptnames.sink(sel) abort
    execute 'edit' s:into_filename(a:sel)
endfunction

function s:scriptnames.on_move() abort
    let l:fname = s:into_filename(g:clap.display.getcurline())
    return clap#preview#file(l:fname)
endfunction

let s:scriptnames.syntax = 'clap_scriptnames'
" let s:scriptnames.on_move_async = function('clap#impl#on_move#async')
let g:clap#provider#scriptnames# = s:scriptnames

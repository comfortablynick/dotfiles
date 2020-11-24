" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Clap provider to display global vim variables

let s:globals = {}

function s:globals.source()
    let l:slen = 30
    let l:vals = []
    for [l:k, l:v] in items(g:)
        let l:v = string(l:v)
        let l:vals += ['let g:'..l:k..' = '..l:v]
    endfor
    return l:vals
endfunction

function s:globals.sink(sel)
    execute 'Redir PP' matchstr(a:sel, 'g:\S*')
    setlocal syntax=vim
endfunction

let s:globals.syntax = 'vim'

function s:globals.on_move()
    let l:curline = g:clap.display.getcurline()
    let l:varname = matchstr(l:curline, 'g:\S*')
    let l:var = execute('PP '..l:varname)
    call clap#preview#show_lines(split(l:var, '\n'), 'vim', 0)
endfunction

let g:clap#provider#globals# = s:globals

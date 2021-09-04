" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Clap provider to display global vim variables

let s:globals = {'syntax': 'vim'}

function s:globals.source() abort
    let l:slen = 30
    let l:vals = []
    for [l:k, l:V] in items(g:) " Need capitalized var in case of funcref
        call add(l:vals, printf('g:%s = %s', l:k, string(l:V)))
    endfor
    return l:vals
endfunction

function s:globals.sink(sel) abort
    execute 'Redir PP' matchstr(a:sel, 'g:\S*')
    setlocal syntax=vim
endfunction

function s:globals.on_move() abort
    let l:curline = g:clap.display.getcurline()
    let l:varname = matchstr(l:curline, 'g:\S*')
    let l:var = execute('PP '..l:varname)
    call clap#preview#show_lines(split(l:var, '\n'), 'vim', 0)
endfunction

let g:clap#provider#globals# = s:globals

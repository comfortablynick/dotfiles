" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Show a list of floaterm buffer instances

let s:spec = {}
let s:preview_height = 10
let s:bufnr_width = 7
let s:name_width = 60
let s:fmt = '%'..s:bufnr_width..'s      %-'..s:name_width..'s'..'   %s'
let s:bar = printf(s:fmt, '[bufnr]', '[name]', '[title]')

function s:spec.source()
    let l:candidates = [s:bar]
    let l:bufs = floaterm#buflist#gather()
    for l:bufnr in l:bufs
        let l:bufinfo = getbufinfo(l:bufnr)[0]
        let l:name = l:bufinfo['name']
        " TODO: improve title appearance
        let l:title = l:bufinfo['variables']['term_title']
        let l:line = printf(s:fmt, l:bufnr, l:name, l:title)
        call add(l:candidates, l:line)
    endfor
    return l:candidates
endfunction

function s:spec.on_move()
    let l:curline = g:clap.display.getcurline()
    if l:curline ==# s:bar | return | endif
    let l:bufnr = str2nr(matchstr(l:curline, '\d\+'))
    let l:lnum = getbufinfo(l:bufnr)[0]['lnum']
    let l:lines = getbufline(l:bufnr, min([max([l:lnum-s:preview_height, 0]), 0]), '$')
    let l:lines = l:lines[min([max([len(l:lines)-s:preview_height, 0]), 0]):]
    call g:clap.preview.show(l:lines)
endfunction

function s:spec.sink(curline)
    if a:curline ==# s:bar | return | endif
    let l:bufnr = str2nr(matchstr(a:curline, '\d\+'))
    call floaterm#terminal#open_existing(l:bufnr)
endfunction

let g:clap#provider#floaterms# = s:spec

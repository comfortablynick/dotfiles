" ====================================================
" Filename:    autoload/config/clap.vim
" Description: Lazy-loaded providers for clap.vim
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-16 16:58:34 CST
" ====================================================

" Maps :: show defined maps for all modes
let config#clap#maps = {}

function! config#clap#maps.source() abort
    let l:maps = nvim_exec('map', 1)
    return split(l:maps, '\n')
endfunction

function! config#clap#maps.sink() abort
    return ''
endfunction

let config#clap#scriptnames = {}

function! config#clap#scriptnames.source() abort
    let l:names = nvim_exec('scriptnames', 1)
    return split(l:names, '\n')
endfunction

function! config#clap#scriptnames.sink() abort
    return ''
endfunction

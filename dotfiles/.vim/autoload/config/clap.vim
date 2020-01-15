" ====================================================
" Filename:    autoload/config/clap.vim
" Description: Lazy-loaded providers for clap.vim
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-14 18:45:10 CST
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

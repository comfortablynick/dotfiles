" ====================================================
" Filename:    autoload/config/clap.vim
" Description: Lazy-loaded providers for clap.vim
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-23 09:16:38 CST
" ====================================================

" Maps :: show defined maps for all modes
let s:maps = {}
function! s:maps.source() abort
    let l:maps = nvim_exec('map', 1)
    return split(l:maps, '\n')
endfunction

function! s:maps.sink() abort
    return ''
endfunction

let config#clap#maps = s:maps

" Scriptnames
let s:scriptnames = {}
function! s:scriptnames.source() abort
    let l:names = nvim_exec('scriptnames', 1)
    return split(l:names, '\n')
endfunction

function! s:scriptnames.sink() abort
    return ''
endfunction

let config#clap#scriptnames = s:scriptnames

" History
function! config#clap#history() abort
    let l:hist = filter(map(range(1, histnr(':')), 'histget(":", - v:val)'), '!empty(v:val)')
    let cmd_hist_len = len(l:hist)
    return map(l:hist, 'printf("%4d", cmd_hist_len - v:key)."  ".v:val')
endfunction

" Much faster lua implementation
function! config#clap#history_lua() abort
    return luaeval('require("tools").get_history()')
endfunction

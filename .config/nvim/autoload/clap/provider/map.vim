" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Show defined maps for all modes

" Keep this for now; built-in `maps` provider is confusing with which mode is shown
let s:map = {}

let s:map.source = {-> split(execute('map'), '\n')}
let s:map.sink = {-> v:null}

let s:map.syntax = 'vim'
let g:clap#provider#map# = s:map

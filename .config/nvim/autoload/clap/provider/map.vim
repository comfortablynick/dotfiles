" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Show maps with syntax highlighting
let s:allowed_mode = ['n', 'i', 'x', 'o']

let s:mode = get(g:clap.context, 'mode', 'n')
if index(s:allowed_mode, s:mode) == -1
    let s:mode = 'n'
endif

" let s:map = g:clap#provider#maps#
let s:map ={}

let s:tools = v:lua.require('tools')

let s:map.source = s:tools.get_maps(s:mode)
let s:map.syntax = 'vim'

function s:map.sink(sel)
    execute 'verb' s:mode..'map' matchstr(a:sel, '^\S*')
endfunction

let g:clap#provider#map# = s:map

" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: View files from output of `:scriptnames`

let s:scriptnames = {}

let s:fname = { v -> split(v, ' ')[-1] }
let s:scriptnames.source  = { -> split(execute('scriptnames'), '\n') }
let s:scriptnames.on_move = { -> clap#preview#file(s:fname(g:clap.display.getcurline())) }
let s:scriptnames.sink    = { v -> execute('edit '.. s:fname(v)) }
let s:scriptnames.syntax  = 'clap_scriptnames'
let g:clap#provider#scriptnames# = s:scriptnames

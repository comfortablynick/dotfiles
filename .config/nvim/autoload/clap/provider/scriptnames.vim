" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: View files from output of `:scriptnames`

let s:scriptnames = {}

function s:into_qf_item(line) abort
    let l:split = split(a:line, ' ')
  return {'filename': expand(l:split[-1]), 'text': matchstr(l:split[0], '^\d\+')}
endfunction

function s:sink_star(lines) abort
    call setqflist([], ' ', {
        \ 'items': map(a:lines, {_,v->s:into_qf_item(v)}), 
        \ 'title': 'Clap scriptnames'},
        \)
    call qf#open()
    cc
endfunction

let s:scriptnames.source  = { -> split(execute('scriptnames'), '\n') }
let s:scriptnames.on_move = { -> plugins#clap#file_preview() }
let s:scriptnames.sink    = { v -> plugins#clap#file_edit(v) }
let s:scriptnames.syntax  = 'clap_scriptnames'
let s:scriptnames['sink*'] = function('s:sink_star')

let g:clap#provider#scriptnames# = s:scriptnames

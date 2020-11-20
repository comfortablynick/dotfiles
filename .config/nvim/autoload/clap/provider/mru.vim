" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Most recently used

let s:mru = {}

function s:mru.source()
    let s:using_icons = v:true
    let l:files = luaeval('require"tools".mru_files()')
    let l:files = filter(l:files, {_,v -> v !=# expand('%:p:~')})
    return map(l:files, {_,v -> clap#icon#get(v)..' '..v})
endfunction

let s:mru.on_move = { -> plugins#clap#file_preview()}
let s:mru.sink = {sel -> plugins#clap#file_edit(sel)}

let g:clap#provider#mru# = s:mru

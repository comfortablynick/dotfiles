" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Show maps with syntax highlighting (nvim only)
if !has('nvim') | finish | endif 
let s:allowed_modes = ['n', 'i', 'x', 'o', 'v']

let s:map = {}
let s:map.syntax = 'vim'

function s:get_mode()
    let l:mode = get(g:clap.context, 'mode', 'n')
    if index(s:allowed_modes, l:mode) == -1
        let l:mode = 'n'
    endif
    return l:mode
endfunction

function s:map.source()
    let l:mode = s:get_mode()
    let l:self.prompt_format = ' %spinner%%forerunner_status% '..l:mode..'map:'
    call clap#spinner#refresh()
    return luaeval('require"tools".get_maps(_A[1], _A[2])', [l:mode, bufnr('')])
endfunction

function s:map.sink(sel)
    execute 'verbose' s:get_mode()..'map' matchstr(a:sel, '^\S*')
endfunction

let g:clap#provider#map# = s:map

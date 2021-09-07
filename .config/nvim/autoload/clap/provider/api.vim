" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Get help for nvim api functions

let s:api = {}

let s:api.source = luaeval('vim.tbl_keys(vim.api)')
let s:api.sink = {s -> execute('help '..s)}

" TODO: replace with formatted function signatures
function s:api.on_move() abort
    let l:curline = g:clap.display.getcurline()
    let l:var = luaeval('vim.inspect(vim.tbl_filter(function(v) return v.name == _A end, vim.fn.api_info().functions)[1])', l:curline)
    call clap#preview#show_lines(split(l:var, '\n'), 'lua', 0)
endfunction

let g:clap#provider#api# = s:api

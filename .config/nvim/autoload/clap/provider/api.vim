" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Get help for nvim api functions

let s:api = {}

" TODO: replace with more detail from api_info()
let s:api.source = luaeval('vim.tbl_keys(vim.api)')
let s:api.sink = {s -> execute(window#tab_mod('h', 'help')..' '..s)}

let g:clap#provider#api# = s:api

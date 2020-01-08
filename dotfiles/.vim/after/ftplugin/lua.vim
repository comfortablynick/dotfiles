" ====================================================
" Filename:    after/ftplugin/lua.vim
" Description: Lua filetype overrides
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 07:16:49 CST
" ====================================================
if exists('g:loaded_after_ftplugin_lua_dzkzqoxu') | finish | endif
let g:loaded_after_ftplugin_lua_dzkzqoxu = 1

" Lua development tools
" silent! packadd nvim-luadev

" Override vim ftplugin and set not to add comment leader on new line
setlocal formatoptions-=o formatoptions-=r

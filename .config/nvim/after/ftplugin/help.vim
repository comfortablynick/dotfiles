" ====================================================
" Filename:    after/ftplugin/help.vim
" Description: Settings/overrides for help filetypes
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-03-11 00:30:57 CDT
" ====================================================
let s:guard = 'g:loaded_after_ftplugin_help' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Maps
" Execute line/selection
nnoremap <silent><buffer> yxx      <Cmd>execute getline('.')<CR>
xnoremap <silent><buffer> <Enter> :<C-U>keeppatterns '<,'>g/^/exe getline('.')<CR>

" setlocal statusline=%<%f\ %h%m%r

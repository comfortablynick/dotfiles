" ====================================================
" Filename:    after/ftplugin/help.vim
" Description: Settings/overrides for help filetypes
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-28 08:01:24 CST
" ====================================================
let s:guard = 'g:loaded_after_ftplugin_help' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Maps
" Execute line/selection
nnoremap <silent><buffer> yxx      <Cmd>execute getline('.')<CR>
xnoremap <silent><buffer> <Enter> :<C-U>keeppatterns '<,'>g/^/exe getline('.')<CR>

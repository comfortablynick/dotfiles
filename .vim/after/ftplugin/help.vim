" ====================================================
" Filename:    after/ftplugin/help.vim
" Description: Settings/overrides for help filetypes
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-19 08:28:48 CST
" ====================================================
if exists('g:loaded_after_ftplugin_help') | finish | endif
let g:loaded_after_ftplugin_help = 1

" Maps
" Execute line/selection
nnoremap <silent><buffer> yxx      <Cmd>execute getline('.')<CR>
xnoremap <silent><buffer> <Enter> :<C-U>keeppatterns '<,'>g/^/exe getline('.')<CR>

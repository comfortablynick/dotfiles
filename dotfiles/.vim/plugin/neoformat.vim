" ====================================================
" Filename:    after/plugin/config/neoformat.vim
" Description: Async formatting config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-11-27
" ====================================================
if exists('g:loaded_plugin_neoformat_n7k61rqd') | finish | endif
let g:loaded_plugin_neoformat_n7k61rqd = 1

" Maps/Commands
noremap <silent> <F3> :call config#neoformat#run()<CR>

augroup neoformat_config
    autocmd!
    autocmd BufWritePre *.{bash,sh,lua} :call config#neoformat#run()
augroup END

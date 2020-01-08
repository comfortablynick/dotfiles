" ====================================================
" Filename:    after/plugin/config/neoformat.vim
" Description: Async formatting config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:53:04 CST
" ====================================================
if exists('g:loaded_plugin_neoformat_n7k61rqd')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_neoformat_n7k61rqd = 1

" Maps/Commands
noremap <silent> <F3> :call config#neoformat#run()<CR>

augroup neoformat_config
    autocmd!
    autocmd BufWritePre *.{bash,sh,lua} :call config#neoformat#run()
augroup END

" ====================================================
" Filename:    plugin/runner.vim
" Description: Run commands located in justfile
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-05
" ====================================================
if exists('g:loaded_plugin_runner_btro6nqr') | finish | endif
let g:loaded_plugin_runner_btro6nqr = 1

nnoremap <silent> <Leader>r :call runner#run_cmd('run')<CR>
nnoremap <silent> <Leader>w :w \| :call runner#run_cmd('install')<CR>
nnoremap <silent> <Leader>b :call runner#run_cmd('build')<CR>
" nnoremap <silent> <Leader>c :call runner#run_cmd('test')<CR>

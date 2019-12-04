" ====================================================
" Filename:    plugin/runner.vim
" Description: Run commands located in justfile
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-04
" ====================================================
if exists('g:loaded_runner_vim')
    finish
endif
let g:loaded_runner_vim = 1

nnoremap <silent> <Leader>r :call runner#run_cmd('run')<CR>
nnoremap <silent> <Leader>w :w \| :call runner#run_cmd('install')<CR>
nnoremap <silent> <Leader>b :call runner#run_cmd('build')<CR>
" nnoremap <silent> <Leader>c :call runner#run_cmd('test')<CR>

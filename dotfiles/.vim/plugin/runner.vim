" ====================================================
" Filename:    plugin/runner.vim
" Description: Run commands located in justfile
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-05
" ====================================================
if exists('g:loaded_plugin_runner_btro6nqr') | finish | endif
let g:loaded_plugin_runner_btro6nqr = 1

" Put filetypes here if we need to pause between
" saving and executing the command
let s:wait_before_run_fts = ['rust']

function! s:run(cmd) abort
    if &modified
        write
        if index(s:wait_before_run_fts, &filetype) >= 0
            sleep 500m
        endif
    endif
    call runner#run_cmd(a:cmd)
endfunction

nnoremap <silent> <Leader>r :call runner#run_cmd('run')<CR>
nnoremap <silent> <Leader>w :call <SID>run('install')<CR>
nnoremap <silent> <Leader>b :call runner#run_cmd('build')<CR>
" nnoremap <silent> <Leader>c :call runner#run_cmd('test')<CR>

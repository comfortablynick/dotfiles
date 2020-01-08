" ====================================================
" Filename:    plugin/runner.vim
" Description: Run commands located in justfile
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:55:24 CST
" ====================================================
if exists('g:loaded_plugin_runner_btro6nqr')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_runner_btro6nqr = 1

let g:use_term = 0                                              " Use term instead of Vtr/AsyncRun
let g:run_code_with = 'term'
let g:VtrStripLeadingWhitespace = 0                             " Useful for Python to avoid messing up whitespace
let g:VtrClearEmptyLines = 0                                    " Disable clearing if blank lines are relevant
let g:VtrAppendNewline = 1                                      " Add newline to multiline send
let g:VtrOrientation = 'h'                                      " h/v split
let g:VtrPercentage = 40                                        " Percent of tmux window the runner pane with occupy

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

nmap <silent> <Leader>a <Plug>(VtrAttachToPane)
nmap <silent> <Leader>x <Plug>(VtrKillRunner)

nnoremap <silent> <Leader>r :call runner#run_cmd('run')<CR>
nnoremap <silent> <Leader>w :call <SID>run('install')<CR>
nnoremap <silent> <Leader>b :call runner#run_cmd('build')<CR>
" nnoremap <silent> <Leader>c :call runner#run_cmd('test')<CR>

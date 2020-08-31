let s:guard = 'g:loaded_autoload_plugins_asyncrun' | if exists(s:guard) | finish | endif
let {s:guard} = 1

let g:asyncrun_open = 0                                         " Show quickfix when executing command
let g:asyncrun_bell = 0                                         " Ring bell when job finished
let g:quickfix_run_scroll = 0                                   " Scroll when running code
let g:asyncrun_raw_output = 0                                   " Don't process errors on output
let g:asyncrun_save = 0                                         " Save file before running
let g:asyncrun_rootmarks = [
    \ '.git',
    \ '.svn',
    \ '.project',
    \ '.root',
    \ '.hg',
    \ 'justfile',
    \ 'cargo.toml',
    \ 'go.mod',
    \ ]

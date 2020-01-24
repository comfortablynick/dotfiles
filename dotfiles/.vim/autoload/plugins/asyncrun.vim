if exists('g:loaded_autoload_plugins_asyncrun') | finish | endif
let g:loaded_autoload_plugins_asyncrun = 1

function! plugins#asyncrun#post() abort
    let g:asyncrun_open = 10                                        " Show quickfix when executing command
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

    " Use AyncRun for Make
    command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
endfunction

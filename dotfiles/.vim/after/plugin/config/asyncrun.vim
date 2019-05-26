if exists('g:loaded_asyncrun_config_vim') || !exists(':AsyncRun')
    finish
endif
let g:loaded_asyncrun_config_vim = 1

let g:asyncrun_open = 10                                        " Show quickfix when executing command
let g:asyncrun_bell = 0                                         " Ring bell when job finished
let g:quickfix_run_scroll = 0                                   " Scroll when running code
let g:asyncrun_raw_output = 0                                   " Don't process errors on output
let g:asyncrun_save = 0                                         " Save file before running

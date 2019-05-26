if exists('g:loaded_vtr_config_vim') || !exists(':VtrAttachToPane')
    finish
endif
let g:loaded_vtr_config_vim = 1

let g:use_term = 0                                              " Use term instead of Vtr/AsyncRun
let g:run_code_with = 'term'
let g:VtrStripLeadingWhitespace = 0                             " Useful for Python to avoid messing up whitespace
let g:VtrClearEmptyLines = 0                                    " Disable clearing if blank lines are relevant
let g:VtrAppendNewline = 1                                      " Add newline to multiline send
let g:VtrOrientation = 'h'                                      " h/v split
let g:VtrPercentage = 40                                        " Percent of tmux window the runner pane with occupy
let g:VtrInitialCommand = 'LS_AFTER_CD=0'                       " Turn off auto 'ls after cd'

let g:vtr_filetype_runner_overrides = {
    \ 'go': 'go run *.go',
    \ 'rust': 'cargo run',
    \ 'cpp': 'build/gitpr',
    \ }

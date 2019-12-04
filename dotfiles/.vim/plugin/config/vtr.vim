" ====================================================
" Filename:    plugin/config/vtr.vim
" Description: Configure options and commands for VimTmuxRunner
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-04
" ====================================================
if exists('g:loaded_vtr_vim_jmiy9l4g') | finish | endif
let g:loaded_vtr_vim_jmiy9l4g = 1

let g:use_term = 0                                              " Use term instead of Vtr/AsyncRun
let g:run_code_with = 'term'
let g:VtrStripLeadingWhitespace = 0                             " Useful for Python to avoid messing up whitespace
let g:VtrClearEmptyLines = 0                                    " Disable clearing if blank lines are relevant
let g:VtrAppendNewline = 1                                      " Add newline to multiline send
let g:VtrOrientation = 'h'                                      " h/v split
let g:VtrPercentage = 40                                        " Percent of tmux window the runner pane with occupy
" let g:VtrInitialCommand = 'LS_AFTER_CD=0'                       " Turn off auto 'ls after cd'

nnoremap <silent> <Leader>a :VtrAttachToPane<CR>
nnoremap <silent> <Leader>x :VtrKillRunner<CR>
noremap  <silent> <C-b>     :VtrSendFile!<CR>

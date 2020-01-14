" ====================================================
" Filename:    after/plugin/neoformat.vim
" Description: Plugin settings for neoformat
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-14 12:10:02 CST
" ====================================================
if exists('g:loaded_after_plugin_neoformat_sgyavx6j')
    \ || !exists(':Neoformat')
    finish
endif
let g:loaded_after_plugin_neoformat_sgyavx6j = 1

noremap <silent> <F3> :Neoformat<CR>

" Global Settings
let g:neoformat_try_formatprg = 1        " Use formatprg if defined
let g:neoformat_run_all_formatters = 1   " By default, stops after first formatter succeeds
let g:neoformat_basic_format_align = 1   " Enable basic formatting
let g:neoformat_basic_format_retab = 1   " Enable tab -> spaces
let g:neoformat_basic_format_trim = 1    " Trim trailing whitespace

" Filetype-specific formatters
let g:neoformat_enabled_python = [
    \   'black',
    \   'isort',
    \ ]
let g:neoformat_enabled_typescript = [ 'prettier' ]
let g:neoformat_enabled_javascript = [ 'prettier' ]
let g:neoformat_typescript_prettier = {
    \ 'exe': 'prettier',
    \ 'args': [
    \   '--tab-width 4',
    \   '--trailing-comma es5',
    \   '--stdin',
    \   '--stdin-filepath',
    \   '"%:p"',
    \ ],
    \ 'stdin': 1,
    \ }

let g:neoformat_cmake_cmakeformat = {
    \ 'exe': 'cmake-format',
    \ 'args': ['--config-file $HOME/.config/cmake/cmake-format.py'],
    \ }
" Same options for javascript
let g:neoformat_javascript_prettier = g:neoformat_typescript_prettier

let g:neoformat_enabled_go = [ 'goimports' ]
let g:neoformat_enabled_yaml = [ 'prettier' ]
let g:neoformat_enabled_lua = []

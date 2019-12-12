" ====================================================
" Filename:    autoload/config/neoformat.vim
" Description: Lazy load neoformat config upon execution
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-12
" ====================================================

function! s:neoformat_set_opts() abort
    let g:loaded_neoformat_config_vim = 1

    " Global Settings
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
    let g:neoformat_enabled_lua = [ 'luaformat', 'luafmt' ]
endfunction

" Load neoformat on first run and load options before calling
function! config#neoformat#run() abort
    if !exists(':Neoformat')
        packadd neoformat
        call s:neoformat_set_opts()
    end
    Neoformat
endfunction

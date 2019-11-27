" ====================================================
" Filename:    autoload/neoformat/formatters/lua.vim
" Description: Custom formatters for lua scripts
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-11-27
" ====================================================

function! neoformat#formatters#lua#enabled() abort
    return ['lua-format']
endfunction

function! neoformat#formatters#lua#luaformat() abort
    return {
        \ 'exe': 'lua-format',
        \ 'args': ['--config=$XDG_CONFIG_HOME/.lua-format'],
        \ 'stdin': 1
        \ }
endfunction

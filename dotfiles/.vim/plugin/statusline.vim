" ====================================================
" Filename:    plugin/statusline.vim
" Description: Set statusline
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-28 15:53:15 CST
" ====================================================
let g:loaded_plugin_statusline = 1
if exists('g:loaded_plugin_statusline')
    \ || exists('*lightline#update')
    finish
endif
let g:loaded_plugin_statusline = 1

function! s:def(fn) abort
    return printf(' %%{v:lua.ll.%s()} ', a:fn)
endfunction

function! s:statusline() abort
    if v:lua.ll.is_not_file() == v:true
        let l:statusline_default = '%<%f %h%m%r%=%-14.(%l,%c%V%) %P'
        return l:statusline_default
    endif
    let l:mode = s:def('vim_mode')
    let l:fname = s:def('file_name')
    let l:git = s:def('git_status')
    let l:line = s:def('line_info')
    return printf('%s%%<%s%s%%=%s', l:mode, l:fname, l:git, l:line)
endfunction

function! SetStatusline() abort
    let &statusline = s:statusline()
endfunction

call SetStatusline()
" setlocal statusline=%!v:lua.ll.statusline()

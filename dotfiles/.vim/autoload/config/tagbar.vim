" ====================================================
" Filename:    autoload/config/tagbar.vim
" Description: Functions/settings for tagbar
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:32:19 CST
" ====================================================

function! s:set_tagbar_opts() abort
    if exists('g:set_tagbar_opts') | return | endif
    let g:set_tagbar_opts = 1

    let g:tagbar_autoclose = 1                                      " Autoclose tagbar after selecting tag
    let g:tagbar_autofocus = 1                                      " Move focus to tagbar when opened
    let g:tagbar_compact = 1                                        " Eliminate help msg, blank lines
    let g:tagbar_autopreview = 0                                    " Open preview window with selected tag details
    let g:tagbar_sort = 0                                           " Sort tags alphabetically vs. in file order

    " Filetypes
    let g:tagbar_type_typescript = {
        \ 'ctagstype': 'typescript',
        \ 'kinds': [
        \   'c:classes',
        \   'n:modules',
        \   'f:functions',
        \   'v:variables',
        \   'v:varlambdas',
        \   'm:members',
        \   'i:interfaces',
        \   'e:enums',
        \   ]
        \ }
    silent! packadd tagbar
endfunction

function! config#tagbar#tagbar_toggle() abort
    call s:set_tagbar_opts()
    TagbarToggle
endfunction

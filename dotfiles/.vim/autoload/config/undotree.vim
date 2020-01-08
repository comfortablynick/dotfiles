" ====================================================
" Filename:    autoload/config/undotree.vim
" Description: Functions/settings for undotree
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:23:30 CST
" ====================================================

function! s:set_undotree_opts() abort
    if exists('g:set_undotree_opts') | return | endif
    if !exists('g:loaded_undotree')
        silent! packadd undotree
    endif
    let g:set_undotree_opts = 1

    " Show tree on right + diff below
    let g:undotree_WindowLayout = 4
endfunction

" Load and toggle undotree when called
function! config#undotree#toggle_undotree() abort
    call s:set_undotree_opts()
    call undotree#UndotreeToggle()
    call undotree#UndotreeFocus()
endfunction

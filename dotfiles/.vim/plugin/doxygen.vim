" ====================================================
" Filename:    plugin/doxygen.vim
" Description: Abbreviatins for doxygen funcs
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:46:02 CST
" ====================================================

if exists('g:loaded_doxygen_abbr_vim')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_doxygen_abbr_vim = 1

" insert doxygen function header
iabbr _DFH <C-R>=doxygen#func_comment()<CR><ESC>XXi*<esc>?**\n*<CR>A

" insert only parameter list (can be used if param list changed)
iabbr _DFHp <SPACE><C-R>=doxygen#param_list()<CR>

" insert doxygen file header
iabbr _DMH <C-R>=doxygen#file_comment()<CR><ESC>XXi*<esc>?@brief<CR>A

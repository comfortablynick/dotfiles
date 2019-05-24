" set up abbreviations for doxygen autoload funcs

if exists('g:loaded_doxygen_abbr_vim')
    finish
endif
let g:loaded_doxygen_abbr_vim = 1

" insert doxygen function header
iabbr _DFH <C-R>=doxygen#func_comment()<CR><ESC>XXi*<esc>?@brief<CR>A

" insert only parameter list (can be used if param list changed)
iabbr _DFHp <SPACE><C-R>=doxygen#param_list()<CR>

" insert doxygen file header
iabbr _DMH <C-R>=doxygen#file_comment()<CR><ESC>XXi*<esc>?@brief<CR>A

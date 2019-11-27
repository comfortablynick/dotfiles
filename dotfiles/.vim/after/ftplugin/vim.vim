" VIM SCRIPTS ===================================

" Local vim editor settings
setlocal tabstop=4                                              " Treat spaces as tab
let g:vim_indent_cont = &tabstop                                " Indent \ newline escapes
setlocal foldmethod=marker                                      " Fold using markers
setlocal formatoptions-=o                                       " Don't insert comment marker automatically on O, o
setlocal formatoptions-=r                                       " Don't insert comment marker automatically on <Enter>

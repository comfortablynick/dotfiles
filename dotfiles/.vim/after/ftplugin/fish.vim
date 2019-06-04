" Load syntax
Load vim-fish

" Set up :make to use fish for syntax checking.
compiler fish                                                   " Use fish syntax

" Local fish editor settings
" setlocal textwidth=79                                          " Wrap text
setlocal tabstop=4                                              " Treat spaces as tab
setlocal shiftwidth=4                                           " Indent spaces
setlocal expandtab                                              " Expand tab to spaces (always use spaces)
setlocal foldmethod=marker                                      " Fold using markers

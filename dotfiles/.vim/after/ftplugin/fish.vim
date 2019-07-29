" Load syntax
Load vim-fish

" Set up :make to use fish for syntax checking.
compiler fish                                                   " Use fish syntax

" Local fish editor settings
setlocal foldmethod=marker                                      " Fold using markers
setlocal commentstring=#\ %s

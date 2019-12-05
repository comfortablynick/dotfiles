if exists('g:loaded_after_ftplugin_fish_u2qefc9q') | finish | endif
let g:loaded_after_ftplugin_fish_u2qefc9q = 1

" Load syntax
packadd vim-fish

" Set up :make to use fish for syntax checking.
compiler fish
setlocal commentstring=#\ %s

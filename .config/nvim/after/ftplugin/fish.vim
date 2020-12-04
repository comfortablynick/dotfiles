compiler fish

setlocal shiftwidth=4 
setlocal formatoptions-=c
setlocal formatoptions-=r
setlocal formatoptions-=o
setlocal errorformat=%f\ (line\ %l):\ %m
setlocal foldmethod=marker
" packadd ale
call plugins#packadd('ale')

" Error example
" || 00_start_tmux.fish (line 2): Missing end to bala
" || nce this if statement
" || if status is-interactive
" || ^
" || warning: Error while reading file 00_start_tmux.fish

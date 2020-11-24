compiler fish

setlocal shiftwidth=4 
setlocal formatoptions-=cro
setlocal errorformat=%f\ (line\ %l):\ %m
setlocal foldmethod=marker
packadd ale

" Error example
" || 00_start_tmux.fish (line 2): Missing end to bala
" || nce this if statement
" || if status is-interactive
" || ^
" || warning: Error while reading file 00_start_tmux.fish

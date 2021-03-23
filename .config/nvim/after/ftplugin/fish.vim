compiler fish

setlocal shiftwidth=4 
setlocal formatoptions-=c
setlocal formatoptions-=r
setlocal formatoptions-=o
setlocal errorformat=%E%f\ (line\ %l):\ %m
setlocal errorformat+=%C%m
" setlocal errorformat+=%-G%.%#
" setlocal errorformat+=%-C%.%#
setlocal errorformat+=%Z%p^
" setlocal errorformat+=%E
" setlocal errorformat+=%E%m
setlocal foldmethod=marker
" call plugins#packadd('ale')

" Error example
" || 00_start_tmux.fish (line 2): Missing end to balance this if statement
" || if status is-interactive
" || ^
" || warning: Error while reading file 00_start_tmux.fish

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
let b:undo_ftplugin .= '|setl sw< fo< efm< fdm<'

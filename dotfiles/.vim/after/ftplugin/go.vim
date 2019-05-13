" Golang Options
setlocal formatoptions-=t

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal noexpandtab
let &l:shiftwidth = winwidth(0) > 150 ? 8 : 4
let &l:tabstop = winwidth(0) > 150 ? 8 : 4

compiler go

" Vim Tmux Runner maps
" noremap <buffer> <silent> <C-b> :VtrSendCommandToRunner! go run .<CR>
" nnoremap <silent> <Leader>r :VtrSendCommandToRunner! go run .<CR>

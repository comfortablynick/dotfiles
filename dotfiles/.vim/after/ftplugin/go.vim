" Golang Options
setlocal formatoptions-=t

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal noexpandtab

if winwidth(0) > 125
    setlocal shiftwidth=8
    setlocal tabstop=8
else
    setlocal shiftwidth=4
    setlocal tabstop=4
endif

compiler go

" Vim Tmux Runner maps
noremap <buffer> <silent> <C-b> :VtrSendCommandToRunner! go run .<CR>
nnoremap <silent> <Leader>r :VtrSendCommandToRunner! go run .<CR>

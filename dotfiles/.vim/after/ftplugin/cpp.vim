" C++ filetype commands
"
setlocal shiftwidth=2
setlocal tabstop=2

" Vim Tmux Runner maps
" Use standard build subdir
noremap <buffer> <silent> <C-b> :VtrSendCommandToRunner! build/run<CR>
nnoremap <buffer> <silent> <Leader>r :VtrSendCommandToRunner! build/run<CR>

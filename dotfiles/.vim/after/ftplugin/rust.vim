" Rust filetype commands

" Vim Tmux Runner maps
" if g:use_term != 1
"     noremap <buffer> <silent> <C-b> :VtrSendCommandToRunner! cargo run<CR>
"     nnoremap <buffer> <silent> <Leader>r :VtrSendCommandToRunner! cargo run<CR>
" endif

setlocal foldmethod=marker
let g:rust_conceal = 0
let g:rust_conceal_mod_path = 1

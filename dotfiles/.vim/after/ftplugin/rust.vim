" Rust filetype commands

" Vim Tmux Runner maps
noremap <buffer> <silent> <C-b> :VtrSendCommandToRunner! cargo run<CR>
nnoremap <buffer> <silent> <Leader>r :VtrSendCommandToRunner! cargo run<CR>

let g:rust_conceal = 0
let g:rust_conceal_mod_path = 1

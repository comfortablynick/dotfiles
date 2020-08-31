let s:guard = 'g:loaded_autoload_plugins_fugitive' | if exists(s:guard) | finish | endif
let {s:guard} = 1

nnoremap <silent><Leader>gc :Git commit<CR>
nnoremap <silent><Leader>gp :Git push<CR>
nnoremap <silent><Leader>gd :Gvdiffsplit!<CR>
" TODO: use only in &diff
nnoremap <silent><Leader>gh :diffget //2<CR>
nnoremap <silent><Leader>gl :diffget //3<CR>

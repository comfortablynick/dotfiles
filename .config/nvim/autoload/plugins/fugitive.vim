if exists('g:loaded_autoload_plugins_fugitive') | finish | endif
let g:loaded_autoload_plugins_fugitive = 1

function! plugins#fugitive#post() abort
    nnoremap <silent><Leader>gc :Git commit<CR>
    nnoremap <silent><Leader>gp :Git push<CR>
    nnoremap <silent><Leader>gd :Gvdiffsplit!<CR>
    " TODO: use only in &diff
    nnoremap <silent><Leader>gh :diffget //2<CR>
    nnoremap <silent><Leader>gl :diffget //3<CR>
endfunction

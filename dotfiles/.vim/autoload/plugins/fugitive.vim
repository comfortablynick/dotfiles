function! plugins#fugitive#post() abort
    nnoremap <silent><Leader>gs :Gstatus<CR>
    nnoremap <silent><Leader>gp :Gpush<CR>
    nnoremap <silent><Leader>gd :Gvdiffsplit!<CR>
    " TODO: use only in &diff
    nnoremap <silent><Leader>gh :diffget //2<CR>
    nnoremap <silent><Leader>gl :diffget //3<CR>
endfunction

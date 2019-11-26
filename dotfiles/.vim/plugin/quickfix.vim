if exists('g:loaded_quickfix_vim') | finish | endif
let g:loaded_quickfix_vim = 1

" Close qf after lint if empty
augroup quickfix
    autocmd!
    autocmd User ALELintPost call quickfix#close_empty()
    autocmd FileType qf wincmd J
augroup end

nnoremap <silent> <Leader>q :call quickfix#toggle()<CR>
noremap  <silent> <F10>     :call quickfix#toggle()<CR>

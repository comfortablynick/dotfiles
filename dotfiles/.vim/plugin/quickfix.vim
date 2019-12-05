if exists('g:loaded_plugin_quickfix_9wgejmpc') | finish | endif
let g:loaded_plugin_quickfix_9wgejmpc = 1

" Close qf after lint if empty
augroup plugin_quickfix_9wgejmpc
    autocmd!
    autocmd User ALELintPost call quickfix#close_empty()
    autocmd FileType qf wincmd J
augroup end

nnoremap <silent> <Leader>q :call quickfix#toggle()<CR>
noremap  <silent> <F10>     :call quickfix#toggle()<CR>

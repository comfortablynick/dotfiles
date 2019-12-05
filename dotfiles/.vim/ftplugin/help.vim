if exists('g:loaded_ftplugin_help_ao4k6rvp') | finish | endif
let g:loaded_ftplugin_help_ao4k6rvp = 1

" Find next help tag
augroup ftplugin_help_ao4k6rvp
    autocmd!
    autocmd BufWinEnter <buffer> wincmd o
augroup END

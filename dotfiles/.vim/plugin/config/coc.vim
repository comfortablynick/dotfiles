" Coc.nvim config
if exists('g:loaded_coc_config')
    finish
endif
let g:loaded_coc_config = 1

" Call func to set autocmds if LC is loaded
augroup coc_config
    autocmd!
    autocmd User CocNvimInit call config#coc#init()
    autocmd FileType *
        \ if index(g:completion_filetypes['coc'], &filetype) >= 0
        \ | packadd coc.nvim
        \ | endif
augroup END

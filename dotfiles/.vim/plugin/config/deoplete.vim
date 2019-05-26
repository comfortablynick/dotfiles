if exists('g:loaded_deoplete_config_vim')
    finish
endif
let g:loaded_deoplete_config_vim = 1

" Load deoplete
augroup deoplete_config
    autocmd!
    autocmd FileType *
        \ if index(g:completion_filetypes['deoplete'], &filetype) >= 0
        \ | call deoplete_config#init()
        \ | endif
augroup END

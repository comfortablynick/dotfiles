if exists('g:loaded_deoplete_config_vim')
    finish
endif
let g:loaded_deoplete_config_vim = 1

" Load deoplete
augroup deoplete_config
    autocmd!
    autocmd FileType *
        \ if exists('g:completion_filetypes') &&
        \ index(g:completion_filetypes['deoplete'], &filetype) >= 0
        \ | call config#deoplete#init()
        \ | endif
augroup END

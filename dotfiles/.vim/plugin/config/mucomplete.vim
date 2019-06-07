if exists('g:loaded_mucomplete_vim_config')
    finish
endif
let g:loaded_mucomplete_vim_config = 1

function! s:init_mucomplete() abort
    let g:mucomplete#enable_auto_at_startup = 1
    set completeopt+=menuone,noinsert
    packadd vim-mucomplete
endfunction

" Load mucomplete and config automatically
augroup mucomplete_config
    autocmd!
    autocmd FileType *
        \ if index(g:completion_filetypes['coc'], &filetype) < 0
        \ && index(g:completion_filetypes['deoplete'], &filetype) < 0
        \ | call s:init_mucomplete()
        \ | endif
augroup END

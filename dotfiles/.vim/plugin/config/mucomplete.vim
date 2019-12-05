if exists('g:loaded_plugin_config_mucomplete_vxafc3iu') | finish | endif
let g:loaded_plugin_config_mucomplete_vxafc3iu = 1

function! s:init_mucomplete() abort
    let g:mucomplete#enable_auto_at_startup = 1
    set completeopt+=menuone,noinsert
    packadd vim-mucomplete
endfunction

" Load mucomplete and config automatically
augroup mucomplete_config
    autocmd!
    autocmd FileType *
        \ if exists('g:completion_filetypes') &&
        \ index(g:completion_filetypes['mucomplete'], &filetype) >= 0
        \ | call s:init_mucomplete()
        \ | endif
augroup END

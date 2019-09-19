" Coc.nvim config
if exists('g:loaded_coc_config')
    finish
endif
let g:loaded_coc_config = 1

" let g:coc_force_debug = 1
let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-json',
    \ 'coc-rls',
    \ 'coc-python',
    \ 'coc-tsserver',
    \ 'coc-git',
    \ 'coc-vimlsp',
    \ 'coc-yank',
    \ 'coc-highlight',
    \ 'coc-yaml',
    \ 'coc-pairs',
    \ ]

let g:coc_filetype_map = {
    \ 'yaml.ansible': 'yaml'
    \ }

" Call func to set autocmds if LC is loaded
augroup coc_config
    autocmd!
    autocmd User CocNvimInit call config#coc#init()
    autocmd FileType *
        \ if exists('g:completion_filetypes') &&
        \ index(g:completion_filetypes['coc'], &filetype) >= 0
        \ | packadd coc.nvim
        \ | endif
augroup END

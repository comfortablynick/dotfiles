" Coc.nvim config
if exists('g:loaded_coc_config')
    finish
endif
let g:loaded_coc_config = 1

" Call func to set autocmds if LC is loaded
augroup coc_config
    autocmd!
    autocmd User CocNvimInit call coc_config#cmds()
    autocmd User CocNvimInit call coc_config#maps()
augroup END

let g:coc_force_debug = 1
let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-json',
    \ 'coc-rls',
    \ 'coc-python',
    \ 'coc-tsserver',
    \ 'coc-go',
    \ 'coc-git',
    \ ]
let g:coc_status_error_sign = 'E'
let g:coc_status_warn_sign = 'W'
let g:coc_snippet_next = '<tab>'

if exists('g:loaded_netrw_vim_config')
    finish
endif
let g:loaded_netrw_vim_config = 1

if get(g:, 'use_nerdtree', 0) == 0
    nnoremap <silent> <Leader>n :Lex<CR>
endif

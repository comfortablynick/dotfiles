if exists('g:loaded_vim_rooter_vim')
    finish
endif
let g:loaded_vim_rooter_vim = 1

let g:rooter_manual_only = 1
let g:rooter_patterns = [
    \ '.clasp.json',
    \ '.git',
    \ '.git/',
    \ 'package-lock.json',
    \ 'package.json',
    \ 'tsconfig.json'
    \ ]

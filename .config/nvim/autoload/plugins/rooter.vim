if exists('g:loaded_autoload_plugins_rooter') | finish | endif
let g:loaded_autoload_plugins_rooter = 1

function! plugins#rooter#pre() abort
    let g:rooter_manual_only = 1
    let g:rooter_patterns = [
        \ '.clasp.json',
        \ '.git',
        \ '.git/',
        \ 'package-lock.json',
        \ 'package.json',
        \ 'tsconfig.json'
        \ ]
endfunction

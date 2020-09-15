let s:guard = 'g:loaded_autoload_plugins_rooter' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#rooter#pre() abort
    let g:rooter_silent_chdir = 1
    let g:rooter_manual_only = 1
    let g:rooter_patterns = [
        \ 'init.vim',
        \ '.clasp.json',
        \ '.git',
        \ '.git/',
        \ 'package-lock.json',
        \ 'package.json',
        \ 'tsconfig.json'
        \ ]
endfunction

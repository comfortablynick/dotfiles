function! plugins#rooter#pre()
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

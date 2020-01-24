if exists('g:loaded_autoload_plugins_nerdtree') | finish | endif
let g:loaded_autoload_plugins_nerdtree = 1

function! plugins#nerdtree#post() abort
    let g:NERDTreeHighlightCursorline = 1
    let g:NERDTreeIgnore = [
        \ '\.pyc$',
        \ '^__pycache__$',
        \ '.vscode',
        \ ]
    let g:NERDTreeShowHidden = 1
    let g:NERDTreeQuitOnOpen = 1
endfunction

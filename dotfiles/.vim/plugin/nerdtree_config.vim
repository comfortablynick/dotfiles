if exists('g:loaded_nerdtree_config')
    finish
endif
let g:loaded_nerdtree_config = 1

let NERDTreeHighlightCursorline = 1
let NERDTreeIgnore = [
    \ '\.pyc$',
    \ '^__pycache__$',
    \ '.vscode',
    \ ]
let NERDTreeShowHidden = 1
let NERDTreeQuitOnOpen = 1

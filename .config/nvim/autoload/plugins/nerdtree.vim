let s:guard = 'g:loaded_autoload_plugins_nerdtree' | if exists(s:guard) | finish | endif
let {s:guard} = 1

let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeIgnore = [
    \ '\.pyc$',
    \ '^__pycache__$',
    \ '.vscode',
    \ ]
let g:NERDTreeShowHidden = 1
let g:NERDTreeQuitOnOpen = 1

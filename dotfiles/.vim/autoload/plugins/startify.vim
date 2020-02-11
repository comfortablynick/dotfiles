if exists('g:loaded_autoload_plugins_startify') | finish | endif
let g:loaded_autoload_plugins_startify = 1

function! plugins#startify#pre() abort
    let g:startify_bookmarks = [
        \ {'c': $MYVIMRC},
        \ ]
endfunction

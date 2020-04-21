let s:guard = 'g:loaded_autoload_plugins_startify' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#startify#pre() abort
    let g:startify_bookmarks = [
        \ {'c': $MYVIMRC},
        \ ]
endfunction

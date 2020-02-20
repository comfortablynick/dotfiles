if exists('g:loaded_autoload_plugins_undotree') | finish | endif
let g:loaded_autoload_plugins_undotree = 1

function! plugins#undotree#post() abort
    " Show tree on right + diff below
    let g:undotree_WindowLayout = 4
endfunction

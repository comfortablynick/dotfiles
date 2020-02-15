if exists('g:loaded_autoload_plugins_mucomplete') | finish | endif
let g:loaded_autoload_plugins_mucomplete = 1

function! plugins#mucomplete#pre() abort
    set completeopt+=menuone,noselect
    set shortmess+=c
    let g:mucomplete#enable_auto_at_startup = 1
endfunction

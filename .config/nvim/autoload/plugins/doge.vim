let s:guard = 'g:loaded_autoload_plugins_doge' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#doge#post() abort
    nnoremap <silent> <F4> :DogeGenerate<CR>
endfunction

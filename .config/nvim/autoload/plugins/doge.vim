let s:guard = 'g:loaded_autoload_plugins_doge' | if exists(s:guard) | finish | endif
let {s:guard} = 1

nnoremap <silent> <F4> :DogeGenerate<CR>

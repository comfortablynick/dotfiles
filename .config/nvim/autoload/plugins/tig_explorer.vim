let s:guard = 'g:loaded_autoload_plugins_tig_explorer' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#tig_explorer#post() abort
    nnoremap <silent><Leader>ts :TigStatus<CR>
endfunction

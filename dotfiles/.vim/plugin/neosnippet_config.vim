if exists('g:loaded_neosnippet_config')
    finish
endif
let g:loaded_neosnippet_config = 1

let g:neosnippet#enable_completed_snippet = 1
" autocmd vimrc CompleteDone * if exists('g:loaded_neosnippet') | call neosnippet#complete_done() | endif
autocmd vimrc CompleteDone * call neosnippet#complete_done()

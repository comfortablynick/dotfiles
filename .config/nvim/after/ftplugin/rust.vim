setlocal tabstop=4
setlocal shiftwidth=0
setlocal foldmethod=marker
setlocal formatoptions-=cro
setlocal formatprg=rustfmt\ +nightly
setlocal makeprg=cargo\ install\ --path='.'\ -f

let g:rust_conceal = 0
let g:rust_conceal_mod_path = 1

augroup after_ftplugin_rust
    autocmd!
    " Add {} for the `argument` text object
    " Autocmd will not fire if targets.vim is not installed
    autocmd User targets#mappings#user
        \ call targets#mappings#extend({'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]}})
augroup END

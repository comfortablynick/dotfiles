setlocal tabstop=4
setlocal shiftwidth=0
setlocal foldmethod=marker
setlocal formatoptions-=o
setlocal formatprg=rustfmt\ +nightly
setlocal makeprg=cargo\ install\ --path='.'\ -f

let g:rust_conceal = 0
let g:rust_conceal_mod_path = 1

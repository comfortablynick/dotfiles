if exists('g:loaded_after_ftplugin_rust') | finish | endif
let g:loaded_after_ftplugin_rust = 1

setlocal tabstop=4
setlocal shiftwidth=0
setlocal foldmethod=marker
setlocal formatoptions-=o
setlocal formatoptions-=r
setlocal formatprg=rustfmt\ +nightly
setlocal makeprg=cargo\ install\ --path='.'\ -f

let g:rust_conceal = 0
let g:rust_conceal_mod_path = 1

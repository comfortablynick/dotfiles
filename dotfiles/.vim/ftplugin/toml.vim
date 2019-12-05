if exists('g:loaded_ftplugin_toml_vmie8rp7') | finish | endif
let g:loaded_ftplugin_toml_vmie8rp7 = 1

" Set comment string (the ftplugin in vim-toml doesn't work for some reason)
setlocal commentstring=#\ %s

" Load syntax plugin
packadd vim-toml

if exists('g:toml_ftplugin')
    finish
endif
let g:toml_ftplugin = 1

" Set comment string (the ftplugin in vim-toml doesn't work for some reason)
setlocal commentstring=#\ %s

" Load syntax plugin
packadd vim-toml

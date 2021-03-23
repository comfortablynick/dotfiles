augroup after_ftplugin_tmux
    autocmd!
    autocmd BufWritePost <buffer> silent !tmux source-file % \; display "Sourced config file"
augroup END

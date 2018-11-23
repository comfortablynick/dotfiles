"
"   __   _ _ _ __ ___  _ __ ___
"   \ \ / / | '_ ` _ \| '__/ __|
"    \ V /| | | | | | | | | (__
"     \_/ |_|_| |_| |_|_|  \___|
"
"

" GLOBAL VIM / NEOVIM SETTINGS
" NOTE: Settings may be overridden by filetype plugins

" SHELL =========================================
" Vim apparently doesn't care for fish
" Load bash instead for Vim purposes
if $SHELL =~# 'bin/fish'
    set shell=/bin/sh
endif

" CONFIG FILES ==================================
let g:vim_home = get(g:, 'vim_home', expand('~/.vim/config/'))

let config_list = ['config.vim', 'vim-plug/plug.vim', 'functions.vim', 'theme.vim', 'keymap.vim']

for files in config_list
    for f in glob(g:vim_home.files, 1, 1)
        exec 'source' f
    endfor
endfor

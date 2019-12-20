"  _       _ _         _
" (_)_ __ (_) |___   _(_)_ __ ___
" | | '_ \| | __\ \ / / | '_ ` _ \
" | | | | | | |_ \ V /| | | | | | |
" |_|_| |_|_|\__(_)_/ |_|_| |_| |_|
"

let g:use_init_lua = 1

if get(g:, 'use_init_lua') == 1
    lua require('init').Set_Options()
else
    " Use vim files instead
    let config_list = ['config.vim', 'functions.vim', 'map.vim', 'theme.vim']
    let g:vim_home = get(g:, 'vim_home', expand('$HOME/dotfiles/dotfiles/.vim/config/'))

    for files in config_list
        for f in glob(g:vim_home.files, 1, 1)
            exec 'source' f
        endfor
    endfor

endif

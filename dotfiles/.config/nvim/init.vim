"  _       _ _         _
" (_)_ __ (_) |___   _(_)_ __ ___
" | | '_ \| | __\ \ / / | '_ ` _ \
" | | | | | | |_ \ V /| | | | | | |
" |_|_| |_|_|\__(_)_/ |_|_| |_| |_|
"
" CONFIG FILES ==================================
let config_list = []

let g:use_init_lua = 1

if get(g:, 'use_init_lua') == 1
    lua require('init').Set_Options()
else
    call insert(config_list, 'config.vim')
    call insert(config_list, 'plugins.vim')
    call add(config_list, 'map.vim')
endif

let g:vim_home = get(g:, 'vim_home', expand('$HOME/dotfiles/dotfiles/.vim/config/'))

for files in config_list
    for f in glob(g:vim_home.files, 1, 1)
        exec 'source' f
    endfor
endfor

packadd! lightline.vim
packadd! fzf
packadd! fzf.vim
packadd! ale
packadd! neoformat
packadd! undotree
packadd! vim-sneak
packadd! vim-fugitive
packadd! vim-surround
packadd! vim-localvimrc
packadd! vim-clap
packadd! vim-snippets
packadd! vim-tmux-navigator

if get(g:, 'LL_nf', 0) == 1
    packadd! vim-devicons
endif

" Syntax
packadd! vim-cpp-modern
packadd! vim-markdown
packadd! ansible-vim
packadd! semshi

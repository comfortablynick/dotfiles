" Plugin Management

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

Plug 'vim-airline/vim-airline'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

Plug 'airblade/vim-gitgutter'

" Typescript syntax highlighting
Plug 'leafgarland/typescript-vim'

" Better syntax highlighting, but slow!
"Plug 'HerringtonDarkholme/yats'

" Initialize plugin system
call plug#end()

" NORMAL SETTINGS ================================
set updatetime=100

" Plugin Management =============================

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Plug 'vim-airline/vim-airline'

Plug 'w0rp/ale'

Plug 'Valloric/YouCompleteMe'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

Plug 'airblade/vim-gitgutter'

" Typescript syntax highlighting
Plug 'leafgarland/typescript-vim'

" Better syntax highlighting, but slow!
" Plug 'HerringtonDarkholme/yats'

Plug 'gabrielelana/vim-markdown'

" Initialize plugin system
call plug#end()

" POWERLINE ======================================
set rtp+=/usr/local/lib/python3.7/site-packages/powerline/bindings/vim

" Always show statusline
set laststatus=2

" Use 256 colors
set t_Co=256

" FILETYPE SETTINGS ==============================

" Treat xonsh like python
au BufNewFile,BufRead *.xsh,.xonshrc set ft=python

" EDITOR SETTINGS ================================

" Update more often for gitgutter
set updatetime=100
" Display line numbers
set number

" Try to fix unreadable colors
set background=dark


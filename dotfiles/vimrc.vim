" Plugin Management =============================

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'w0rp/ale'

Plug 'Valloric/YouCompleteMe'

Plug 'airblade/vim-gitgutter'

" Typescript syntax highlighting
" Plug 'leafgarland/typescript-vim'

" Better syntax highlighting, but slow!
Plug 'HerringtonDarkholme/yats'

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

" Indent behavior
set expandtab
set smartindent
set autoindent
set shiftwidth=4
set backspace=2

" LINTING SETTINGS ==============================
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

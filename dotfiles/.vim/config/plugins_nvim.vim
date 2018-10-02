" Plugins for Neovim Only


Plug 'zchee/deoplete-jedi',
\ {
    \ 'for': 'python'
\ }

Plug 'mhartington/nvim-typescript',
\ { 
    \ 'do': [ './install.sh', ':UpdateRemotePlugins' ]
\ }

Plug 'Shougo/deoplete.nvim',
\ {
    \ 'do': ':UpdateRemotePlugins'
\ }

Plug 'Shougo/echodoc',
\ {
    \ 'do': ':UpdateRemotePlugins'
\ }

Plug 'Shougo/neco-vim',
\ {
    \ 'for': 'vim'
\ }

  " Airline
Plug 'vim-airline/vim-airline'                              " Use airline statusbar for nvim
Plug 'vim-airline/vim-airline-themes'                       " Themes for airline
Plug 'plytophogy/vim-virtualenv'                            " Show virtualenv in airline


" PLUGIN CONFIGURATION ==========================

" Airline
let g:airline_extensions = [            
    \ 'tabline', 
    \ 'ale', 
    \ 'branch',
    \ 'hunks',
    \ 'wordcount',
    \ 'virtualenv'
    \ ]
let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 79,
    \ 'x': 40,
    \ 'y': 48,
    \ 'z': 45,
    \ 'warning': 80,
    \ 'error': 80,
    \ }
let g:airline_powerline_fonts = 1
let g:airline_detect_spelllang = 0

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" Echodoc
" TODO: Only execute for python/ts/js?
set cmdheight=1                                 " Add extra line for function definition 
let g:echodoc_enable_at_startup = 1
set shortmess+=c                                " Don't suppress echodoc with 'Match x of x'

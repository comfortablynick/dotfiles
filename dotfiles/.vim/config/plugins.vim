" PLUGIN SETTINGS =============================== 

call plug#begin('~/.vim/plugged')                               " Plugin Manager

" Editor/appearance
Plug 'airblade/vim-gitgutter'                                   " Inline git status
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }          " File explorer panel

" Linting 
Plug 'w0rp/ale'                                                 " Linting

" Syntax highlighting
Plug 'HerringtonDarkholme/yats', { 'for': 'typescript' }        " Typescript
Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }         " Markdown
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}          " Python (enhanced)

" Git
Plug 'junegunn/gv.vim'                                          " Git log/diff explorer
Plug 'tpope/vim-fugitive'                                       " Git wrapper

" Theming
Plug 'ayu-theme/ayu-vim'
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'

if has('nvim')
    " Neovim Only -------------------------------
    Plug 'zchee/deoplete-jedi',
    \ {
        \ 'for': 'python'
    \ }

    Plug 'mhartington/nvim-typescript',
    \ {
        \ 'for': 'typescript',
        \ 'do': './install.sh'
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
else
    " Vim Only ----------------------------------
    set rtp+=/usr/local/lib/python3.7/site-packages/powerline/bindings/vim
    Plug 'Valloric/YouCompleteMe'                               " Code completion (compiled)
    " Plug 'Shougo/deoplete.nvim'                               " Code completion
    " Plug 'roxma/nvim-yarp'                                      " Required by deoplete
    " Plug 'roxma/vim-hug-neovim-rpc'                             " Required by deoplete
endif

call plug#end()


" PLUGIN CONFIGURATION ==========================

" Airline
if has('nvim')
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
endif

" Ale linter
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s (%severity%%: code%)'
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 0
let g:ale_virtualenv_dir_names = ['.env', '.pyenv', 'env', 'dev', 'virtualenv']
let b:ale_linters = {
    \ 'python': [ 'flake8' ]
    \ }

" NERDTree
let NERDTreeHighlightCursorline = 1             " Increase visibility of line
let NERDTreeIgnore = [
    \ '\.pyc$',
    \ '^__pycache__$',
    \ '.vscode'
    \ ]
let NERDTreeShowHidden = 1                      " Show dotfiles

" Deoplete / Echodoc
if has('nvim')
    " Deoplete
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#sources#jedi#show_docstring = 1
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

    " Echodoc
    " TODO: Only execute for python/ts/js?
    set cmdheight=2                                 " Add extra line for function definition 
    let g:echodoc_enable_at_startup = 1
    set shortmess+=c                                " Don't suppress echodoc with 'Match x of x'
endif

"
"   __   _ _ _ __ ___  _ __ ___ 
"   \ \ / / | '_ ` _ \| '__/ __|
"    \ V /| | | | | | | | | (__
"     \_/ |_|_| |_| |_|_|  \___|
"
"

" APPLICATION SETTINGS ==========================

set nocompatible                        " Ignore compatibility issues with Vi
set noswapfile                          " Don't create freaking swap files
set ttyfast                             " Terminal acceleration


if has('nvim')
    " Neovim Only -------------------------------
    set inccommand=split                " Live substitution
    let g:python_host_prog =  
    \expand('$NVIM_PY2_DIR/bin/python') " Python2 binary
    let g:python3_host_prog = 
    \expand('$NVIM_PY3_DIR/bin/python') " Python3 binary
else
    " Vim Only ----------------------------------
    set pyxversion=3                    " Use Python3
    let g:python3_host_prog = '/usr/local/bin/python3.7'
endif


" PLUGIN MANAGEMENT =============================
call plug#begin('~/.vim/plugged')

" Editor/appearance
Plug 'airblade/vim-gitgutter'           " Inline git status
Plug 'scrooloose/nerdtree'              " File explorer panel

" Coding
Plug 'w0rp/ale'                         " Linting

" Syntax highlighting
Plug 'HerringtonDarkholme/yats'         " Typescript (better, but slower)
Plug 'gabrielelana/vim-markdown'        " Markdown
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}  " Python (enhanced)

" Git
Plug 'junegunn/gv.vim'                  " Git log/diff explorer
Plug 'tpope/vim-fugitive'               " Git wrapper

if has('nvim')
    " Neovim Only -------------------------------
    Plug 'zchee/deoplete-jedi'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'mhartington/nvim-typescript'

    " Airline
    Plug 'vim-airline/vim-airline'      " Use airline statusbar for nvim
    Plug 'vim-airline/vim-airline-themes'
    Plug 'plytophogy/vim-virtualenv'    " Show virtualenv in statusbar

    " Theming
    Plug 'ayu-theme/ayu-vim'
    Plug 'arcticicestudio/nord-vim'
    Plug 'morhetz/gruvbox'
else
    " Vim Only ----------------------------------
    set rtp+=/usr/local/lib/python3.7/site-packages/powerline/bindings/vim
    Plug 'Valloric/YouCompleteMe'           " Code completion (compiled)
    " Plug 'Shougo/deoplete.nvim'         " Code completion
    " Plug 'roxma/nvim-yarp'              " Required by deoplete
    " Plug 'roxma/vim-hug-neovim-rpc'     " Required by deoplete
endif

call plug#end()


" FILETYPE SETTINGS ==============================

" Treat xonsh like python
au BufNewFile,BufRead *.xsh,.xonshrc set ft=python

" Gitcommit files 
autocmd FileType gitcommit
    \ exec 'au VimEnter * startinsert'
autocmd FileType gitcommit
    \ call deoplete#custom#buffer_option('auto_complete', v:false)


" EDITOR SETTINGS ================================

" Colors/themes
if has('nvim')
    colorscheme gruvbox             " Color Theme
    let ayucolor = 'mirage'         " For ayu theme
    let g:nord_italic = 1           " Support italic fonts
    let g:nord_italic_comments = 1  " Italic comments
    let g:nord_comment_brightness = 10
    let g:nord_cursor_line_number_background = 1
    let g:gruvbox_italic = 1        " Support italic fonts
    let g:airline_theme = 'gruvbox' " Airline theme (separate from vim)
else
    colorscheme default
endif

set termguicolors               " Display true colors
set background=dark             " Def colors easier on the eyes

" General
syntax enable                   " Syntax highlighting on
set fileformat=unix             " Always use LF and not CRLF
set encoding=utf-8              " Default to unicode
set termencoding=utf-8          " Unicode
set synmaxcol=200               " Don't try to highlight if line > 200 chr
set laststatus=2                " Always show statusline
set number                      " Show linenumbers
set visualbell                  " Visual instead of audible
set nowrap
set noshowmode                  " Hide default mode text (e.g. -- INSERT -- below statusline)
set clipboard=unnamed           " Use system clipboard
set cursorline                  " Show line under cursor's line
set ruler
set showmatch                   " Show matching pair of brackets (), [], {}
set updatetime=100              " Update more often (helps GitGutter)
set signcolumn=yes              " Always show; keep appearance consistent 
set scrolloff=10                " Lines before/after cursor during scroll
set ttimeoutlen=10              " How long in ms to wait for key combinations

" Indent behavior
set expandtab                   " Expand tab to spaces
set smartindent                 " Attempt smart indenting
set autoindent                  " Attempt auto indenting
set shiftwidth=4                " Indent width in spaces
set backspace=2                 " Backspace behaves as expected

" Searching & Replacing
set ignorecase                  " Ignore case while searching
set smartcase                   " Case sensitive if uppercase in pattern
set incsearch                   " Move cursor to matched string

" Jump to last position when reopening file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

" KEYMAPPING ====================================

" Ctrl+n opens NERDTree
map <C-n> :NERDTreeToggle<CR>


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
let b:ale_linters = {'python': ['mypy', 'flake8']}

" NERDTree
let NERDTreeHighlightCursorline = 1             " Increase visibility of line
let NERDTreeIgnore = [
    \ '\.pyc$',
    \ '^__pycache__$'
    \ ]
let NERDTreeShowHidden = 1                      " Show dotfiles

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

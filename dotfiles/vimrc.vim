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
    set t_Co=256                        " Use 256 colors (vim only)
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

if has('nvim')
    " Neovim Only -------------------------------
    Plug 'zchee/deoplete-jedi'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'vim-airline/vim-airline'      " Use airline statusbar for nvim
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
set fileformat=unix             " Always use LF and not CRLF
set encoding=utf-8              " Default to unicode

" EDITOR SETTINGS ================================

syntax enable                   " Syntax highlighting on
set synmaxcol=200               " Don't try to highlight if line > 200 chr
set laststatus=2                " Always show statusline
set number                      " Show linenumbers
set background=dark             " Def colors easier on the eyes
set visualbell                  " Visual instead of audible
set nowrap
set noshowmode                  " Hide default mode text (e.g. -- INSERT -- below statusline)
set clipboard=unnamed           " Use system clipboard
set cursorline                  " Show line under cursor's line
set showmatch                   " Show matching pair of brackets (), [], {}
set updatetime=100              " Update more often (helps GitGutter)
set signcolumn=yes              " Always show; keep appearance consistent 
set scrolloff=10                " Lines before/after cursor during scroll
set termencoding=utf-8          " Unicode

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

" Airline/Powerline
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled=1

" Ale linter
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s (%severity%%: code%)'
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 0
let g:ale_virtualenv_dir_names = ['.env', '.pyenv', 'env', 'dev', 'virtualenv']
let b:ale_linters = {'python': ['mypy', 'flake8']}

" NERDTree
let NERDTreeHighlightCursorline = 1
let NERDTreeIgnore = ['.*\.pyc$']      

" Deoplete
let g:deoplete#enable_at_startup = 1

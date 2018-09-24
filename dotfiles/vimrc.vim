" ===============================================
" ======= VIM / NEOVIM CONFIGURATION ============
" ===============================================

" NEOVIM ========================================
" let g:python_host_prog = '/usr/bin/python'
let g:python_host_prog = expand('$NVIM_PY2_DIR/bin/python')
let g:python3_host_prog = expand('$NVIM_PY3_DIR/bin/python')

" PLUGIN MANAGEMENT =============================
call plug#begin('~/.vim/plugged')

" Editor/appearance
Plug 'airblade/vim-gitgutter'           " Inline git status
Plug 'vim-airline/vim-airline'          " Powerline statusbar
Plug 'scrooloose/nerdtree'              " File explorer panel

" Coding
Plug 'w0rp/ale'                         " Linting
Plug 'Valloric/YouCompleteMe'           " Code completion (compiled)

" Syntax highlighting
Plug 'HerringtonDarkholme/yats'         " Typescript (better, but slower)
" Plug 'leafgarland/typescript-vim'     " Typescript (basic, fast)
Plug 'gabrielelana/vim-markdown'        " Markdown
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}  " Python (enhanced)

call plug#end()


" FILETYPE SETTINGS ==============================

" Treat xonsh like python
au BufNewFile,BufRead *.xsh,.xonshrc set ft=python
set fileformat=unix             " Always use LF and not CRLF

" EDITOR SETTINGS ================================

set laststatus=2                " Always show statusline
set t_Co=256                    " Use 256 colors (vim only)
set number                      " Show linenumbers
set background=dark             " Def colors easier on the eyes

" Indent behavior
set expandtab
set smartindent
set autoindent
set shiftwidth=4
set backspace=2

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

" Ale linter
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s (%severity%%: code%)'
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 0
let g:ale_virtualenv_dir_names = ['.env', '.pyenv', 'env', 'dev', 'virtualenv']
let b:ale_linters = {'python': ['mypy', 'flake8']}

" Gitgutter
set updatetime=100              " Update more often
set signcolumn=yes              " Always show; avoid shifting


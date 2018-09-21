" ===============================================
" ======= VIM / NEOVIM CONFIGURATION ============
" ===============================================


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

call plug#end()


" FILETYPE SETTINGS ==============================

" Treat xonsh like python
au BufNewFile,BufRead *.xsh,.xonshrc set ft=python


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
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 0
let g:ale_virtualenv_dir_names = ['.env', '.pyenv', 'env', 'dev', 'virtualenv']

" Gitgutter
set updatetime=100              " Update more often
set signcolumn=yes              " Always show; avoid shifting


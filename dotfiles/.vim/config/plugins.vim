" PLUGIN SETTINGS =============================== 

call plug#begin('~/.vim/plugged')                               " Plugin Manager

if has('nvim')
    " Load Neovim-only plugins
    exec 'source' vim_home . 'plugins_nvim.vim'
else
    " Load Vim-only plugins
    exec 'source' vim_home . 'plugins_vim.vim'
endif

" Editor/appearance
Plug 'airblade/vim-gitgutter'                                   " Inline git status
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }          " File explorer panel

" Linting 
Plug 'w0rp/ale'                                                 " Linting

" Syntax highlighting
Plug 'HerringtonDarkholme/yats', { 'for': 'typescript' }        " Typescript
Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }         " Markdown
Plug 'dag/vim-fish'                                             " Fish scripts
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}          " Python (enhanced)

" Formatting
Plug 'ambv/black', { 'for': 'python' }                          " Python formatter (subset of PEP8)

" Git
Plug 'junegunn/gv.vim'                                          " Git log/diff explorer
Plug 'tpope/vim-fugitive'                                       " Git wrapper

" Theming
Plug 'ayu-theme/ayu-vim'
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'

call plug#end()


" PLUGIN CONFIGURATION ==========================
" Ale linter
let g:ale_close_preview_on_insert = 1           " Close preview window in INSERT mode
let g:ale_cursor_detail = 1                     " Open preview window when focusing on error
let g:ale_echo_cursor = 0                       " Either this or ale_cursor_detail need to be set to 1
let g:ale_cache_executable_check_failures = 1   " Have to restart vim if adding new providers
let g:ale_lint_on_text_changed = 'never'        " Don't lint while typing (too distracting)
let g:ale_lint_on_insert_leave = 1              " Lint after leaving insert
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

" Black
let g:black_virtualenv = "~/.env/black"      " Black virtualenv location (custom)

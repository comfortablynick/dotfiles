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
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }              " Undo tree panel
Plug '~/.fzf'                                                   " Fuzzy finder
Plug 'junegunn/fzf.vim'                                         " Fuzzy finder vim extension

if $NERD_FONTS != 0
    " Load plugins that require full terminal
    Plug 'ryanoasis/vim-devicons'                               " Developer filetype icons
endif

" Linting
Plug 'w0rp/ale'                                                 " Linting

" Syntax highlighting
Plug 'HerringtonDarkholme/yats', { 'for': 'typescript' }        " Typescript
Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }         " Markdown
Plug 'Soares/fish.vim', { 'for': 'fish' }                       " Fish syntax highlighting

" Formatting
Plug 'ambv/black', { 'for': 'python' }                          " Python formatter (subset of PEP8)

" Git
Plug 'junegunn/gv.vim'                                          " Git log/diff explorer
Plug 'tpope/vim-fugitive'                                       " Git wrapper

" Theming
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'nightsense/snow'

" Executing
Plug 'skywind3000/asyncrun.vim'                                 " Execute commands asynchronously

call plug#end()


" PLUGIN CONFIGURATION ==========================
" Ale linter
let g:ale_close_preview_on_insert = 1                           " Close preview window in INSERT mode
let g:ale_cursor_detail = 0                                     " Open preview window when focusing on error
let g:ale_echo_cursor = 1                                       " Either this or ale_cursor_detail need to be set to 1
let g:ale_cache_executable_check_failures = 1                   " Have to restart vim if adding new providers
let g:ale_lint_on_text_changed = 'never'                        " Don't lint while typing (too distracting)
let g:ale_lint_on_insert_leave = 0                              " Lint after leaving insert
let g:ale_lint_on_enter = 0                                     " Lint when opening file
let g:ale_list_window_size = 5                                  " Show # of lines of errors
let g:ale_open_list = 1                                         " Show quickfix list
let g:ale_set_loclist = 0                                       " Show location list
let g:ale_set_quickfix = 1                                      " Show quickfix list with errors
let g:ale_fix_on_save = 1                                       " Apply fixes when saving
let g:ale_echo_msg_error_str = 'E'                              " Error string prefix
let g:ale_echo_msg_warning_str = 'W'                            " Warning string prefix
let g:ale_echo_msg_format = '[%linter%] %s (%severity%%: code%)'
let g:ale_sign_column_always = 1                                " Always show column on left side, even with no errors/warnings
let g:ale_completion_enabled = 0                                " Enable ALE completion if no other completion engines
let g:ale_virtualenv_dir_names = [
    \ '.env',
    \ '.pyenv',
    \ 'env',
    \ 'dev',
    \ 'virtualenv'
    \ ]
let g:ale_linters = {
    \ 'python':
    \   [
    \     'flake8'
    \   ]
    \ }
let g:ale_fixers = {
    \ '*':
    \  [
    \    'remove_trailing_lines',
    \    'trim_whitespace'
    \  ],
    \ 'python':
    \  [
    \    'black',
    \    'autopep8'
    \  ]
    \ }

" Ale linter settings
let g:python_flake8_options = {
    \ '--max-line-length': 88
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

" Asyncrun
let g:asyncrun_open = 6                                         " Show quickfix when executing command
let g:asyncrun_bell = 1                                         " Ring bell when job finished

" Undotree
let g:undotree_WindowLayout = 4                                 " Show tree on right + diff below

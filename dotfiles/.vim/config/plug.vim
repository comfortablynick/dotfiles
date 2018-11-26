"   ____  _             _                 _
"  |  _ \| |_   _  __ _(_)_ __  _____   _(_)_ __ ___
"  | |_) | | | | |/ _` | | '_ \/ __\ \ / / | '_ ` _ \
"  |  __/| | |_| | (_| | | | | \__ \\ V /| | | | | | |
"  |_|   |_|\__,_|\__, |_|_| |_|___(_)_/ |_|_| |_| |_|
"                 |___/
"
" Common Vim/Neovim plugins
" Helper functions {{{
" Vim-Plug Cond() {{{
" Add conditions that aren't supported directly by vim-plug
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction
" }}}
" }}}
" Plugin definitions {{{
" BEGIN {{{
call plug#begin('~/.vim/plugged')                               " Plugin Manager

if has('nvim')
    " Load Neovim-only plugins
    exec 'source' vim_home . 'vim-plug/nvim.plug.vim'
else
    " Load Vim-only plugins
    exec 'source' vim_home . 'vim-plug/vim.plug.vim'
endif
" }}}
" Editor/appearance {{{
Plug 'airblade/vim-gitgutter'                                   " Inline git status
Plug 'scrooloose/nerdtree',     { 'on': 'NERDTreeToggle' }      " File explorer panel
Plug 'mbbill/undotree',         { 'on': 'UndotreeToggle' }      " Undo tree panel
Plug '~/.fzf'                                                   " Fuzzy finder
Plug 'junegunn/fzf.vim'                                         " Fuzzy finder vim extension
Plug 'ryanoasis/vim-devicons',  Cond(g:LL_nf)                   " Load devicons if $NERD_FONTS = 1
Plug 'christoomey/vim-tmux-navigator',                          " Navigate Vim splits & tmux panes with same keys
    \ Cond(!empty($TMUX_PANE))
" }}}
" Linting {{{
Plug 'w0rp/ale',                                                " Async Linting Engine
"     \ {
"     \   'for': [
"     \       'python',
"     \       'vim',
"     \       'typescript',
"     \       'javascript',
"     \       'cpp',
"     \       'c',
"     \   ]
"     \ }
" }}}
" Syntax highlighting {{{
Plug 'HerringtonDarkholme/yats',    { 'for': 'typescript' }     " Typescript
Plug 'gabrielelana/vim-markdown',   { 'for': 'markdown' }       " Markdown
Plug 'dag/vim-fish',                { 'for': 'fish' }           " Fish script
" }}}
"         Formatting {{{
" Plug 'ambv/black',                                              " Python formatter (subset of PEP8)
"     \ {
"     \   'for': 'python',
"     \   'on': 'Black',
"     \ }
" }}}
" Git {{{
Plug 'junegunn/gv.vim'                                          " Git log/diff explorer
Plug 'tpope/vim-fugitive'                                       " Git wrapper
" }}}
" Theming {{{
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'nightsense/snow'
" }}}
" Terminal/Code Execution {{{
Plug 'skywind3000/asyncrun.vim'                                 " Execute commands asynchronously
" }}}
" Completion/Snippets {{{
Plug 'Shougo/neosnippet.vim'                                    " Programming code snippet framework
Plug 'Shougo/neosnippet-snippets'                               " Code snippets
Plug 'Shougo/echodoc'                                           " Echo completion function definitons

" Deoplete {{{
Plug 'zchee/deoplete-jedi',
    \ Cond(has('nvim'),
    \ {
    \   'for': 'python',
    \ })
Plug 'mhartington/nvim-typescript',
    \ Cond(has('nvim'),
    \ {
    \   'for':
    \       [
    \           'typescript',
    \           'tsx',
    \       ],
    \   'do': './install.sh',
    \ })
Plug 'Shougo/deoplete.nvim',
    \ Cond(has('nvim'),
    \ {
    \   'do': ':UpdateRemotePlugins',
    \ })
Plug 'Shougo/neco-vim', Cond(has('nvim'),
    \ {
    \   'for': 'vim'
    \ })
" }}}
" YouCompleteMe {{{
Plug 'Valloric/YouCompleteMe',          Cond(!has('nvim'),
    \ {
    \   'do': 'python3 ~/git/python/shell/vimsync.py -p -y',
    \   'for':
    \       [
    \           'python',
    \           'javascript',
    \           'typescript',
    \           'cpp',
    \           'c',
    \       ],
    \ })
" }}}
" }}}
" Status line {{{
" Airline {{{
Plug 'vim-airline/vim-airline',         Cond(has('nvim'))
Plug 'vim-airline/vim-airline-themes',  Cond(has('nvim'))
" }}}
" Powerline {{{
" if !has('nvim')
"     set rtp+=/usr/local/lib/python3.7/site-packages/powerline/bindings/vim
" endif
" }}}
" Lightline {{{
Plug 'itchyny/lightline.vim',           Cond(!has('nvim'))
Plug 'maximbaz/lightline-ale',          Cond(!has('nvim'))
Plug 'mgee/lightline-bufferline',       Cond(!has('nvim'))
" }}}
" }}}
" END {{{
call plug#end()
" }}}
" }}}
" Plugin configuration {{{
" Ale linter {{{
let g:ale_close_preview_on_insert = 1                           " Close preview window in INSERT mode
let g:ale_cursor_detail = 0                                     " Open preview window when focusing on error
let g:ale_echo_cursor = 1                                       " Either this or ale_cursor_detail need to be set to 1
let g:ale_cache_executable_check_failures = 1                   " Have to restart vim if adding new providers
let g:ale_lint_on_text_changed = 'never'                        " Don't lint while typing (too distracting)
let g:ale_lint_on_insert_leave = 1                              " Lint after leaving insert
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
let g:python_flake8_options = {
    \ '--max-line-length': 88
    \ }
let g:ale_python_flake8_args = {
    \ '--max-line-length': 88
    \ }
" }}}
" NERDTree {{{
let NERDTreeHighlightCursorline = 1             " Increase visibility of line
let NERDTreeIgnore = [
    \ '\.pyc$',
    \ '^__pycache__$',
    \ '.vscode'
    \ ]
let NERDTreeShowHidden = 1                      " Show dotfiles
" }}}
" Black {{{
let g:black_virtualenv = '~/.env/black'      " Black virtualenv location (custom)
" }}}
" Echodoc {{{
" TODO: Only execute for python/ts/js?
set cmdheight=1                                 " Add extra line for function definition
let g:echodoc_enable_at_startup = 1
" let g:echodoc#type = 'echo'
set noshowmode
set shortmess+=c                                " Don't suppress echodoc with 'Match x of x'
" }}}
" Asyncrun {{{
let g:asyncrun_open = 6                                         " Show quickfix when executing command
let g:asyncrun_bell = 1                                         " Ring bell when job finished
" }}}
" Undotree {{{
let g:undotree_WindowLayout = 4                                 " Show tree on right + diff below
" }}}
" Airline {{{
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

" Airline Tabline
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 0
" }}}
" Deoplete {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
augroup deoplete
    autocmd!
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end
" }}}
" YouCompleteMe {{{
let g:ycm_filetype_blacklist = {
    \ 'gitcommit': 1,
    \ 'tagbar': 1,
    \ 'qf': 1,
    \ 'notes': 1,
    \ 'markdown': 1,
    \ 'unite': 1,
    \ 'text': 1,
    \ 'vimwiki': 1,
    \ 'pandoc': 1,
    \ 'infolog': 1,
    \ 'mail': 1
    \}
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'gitcommit': 1
      \}
let g:ycm_autoclose_preview_window_after_completion = 1         " Ditch preview window after completion
" }}}
" }}}
" vim:set fdl=1:

"   ____  _             _                 _
"  |  _ \| |_   _  __ _(_)_ __  _____   _(_)_ __ ___
"  | |_) | | | | |/ _` | | '_ \/ __\ \ / / | '_ ` _ \
"  |  __/| | |_| | (_| | | | | \__ \\ V /| | | | | | |
"  |_|   |_|\__,_|\__, |_|_| |_|___(_)_/ |_|_| |_| |_|
"                 |___/
"
" Common Vim/Neovim plugins
" Helper functions/variables {{{
" Vim-Plug Cond() {{{
" Add conditions that aren't supported directly by vim-plug
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction
" }}}
" Completion filetypes {{{
let g:completion_filetypes = {
    \ 'deoplete':
    \   [
    \       'python',
    \       'fish',
    \       'vim',
    \       'javascript',
    \       'typescript',
    \       'cpp',
    \       'c',
    \   ],
    \ 'ycm':
    \   [
    \       'python',
    \       'javascript',
    \       'typescript',
    \       'cpp',
    \       'c',
    \   ],
    \ }
" }}}
" }}}
" Plugin definitions {{{
" BEGIN {{{
call plug#begin('~/.vim/plugged')                               " Plugin Manager
" }}}
" Editor/appearance {{{
Plug 'airblade/vim-gitgutter'                                   " Inline git status
Plug 'scrooloose/nerdtree',                                     " File explorer panel
    \ { 'on': 'NERDTreeToggle' }
Plug 'mbbill/undotree',                                         " Undo history panel
    \ { 'on': 'UndotreeToggle' }
Plug '~/.fzf'                                                   " Fuzzy finder system folder
Plug 'junegunn/fzf.vim'                                         " Fuzzy finder vim extension
Plug 'ryanoasis/vim-devicons',                                  " Load devicons if $NERD_FONTS = 1
    \ Cond(g:LL_nf)
Plug 'christoomey/vim-tmux-navigator',                          " Navigate Vim splits & tmux panes with same keys
    \ Cond(!empty($TMUX_PANE))
" }}}
" Linting {{{
Plug 'w0rp/ale',                                                " Async Linting Engine
    \ {
    \   'for': [
    \       'python',
    \       'vim',
    \       'typescript',
    \       'javascript',
    \       'cpp',
    \       'c',
    \   ]
    \ }
" }}}
" Syntax highlighting {{{
Plug 'HerringtonDarkholme/yats',    { 'for': 'typescript' }     " Typescript
Plug 'gabrielelana/vim-markdown',   { 'for': 'markdown' }       " Markdown
Plug 'dag/vim-fish',                { 'for': 'fish' }           " Fish script
" }}}
" Git {{{
Plug 'junegunn/gv.vim'                                          " Git log/diff explorer
Plug 'tpope/vim-fugitive'                                       " Git wrapper
" }}}
" Color themes {{{
" Conditionally load themes based on env var
Plug 'arcticicestudio/nord-vim',
    \ Cond(g:vim_base_color ==? 'nord')
Plug 'morhetz/gruvbox',
    \ Cond(g:vim_base_color ==? 'gruvbox')
Plug 'NLKNguyen/papercolor-theme',
    \ Cond(g:vim_base_color ==? 'papercolor')
Plug 'nightsense/snow',
    \ Cond(g:vim_base_color ==? 'snow')
" }}}
" Terminal/Code Execution {{{
Plug 'skywind3000/asyncrun.vim'                                 " Execute commands asynchronously
" }}}
" Snippets {{{
Plug 'Shougo/neosnippet.vim'                                    " Programming code snippet framework
Plug 'Shougo/neosnippet-snippets'                               " Code snippets
" }}}
" Code completion {{{
Plug 'Shougo/echodoc'                                           " Echo completion function definitons
" Deoplete {{{
Plug 'Shougo/deoplete.nvim',
    \ Cond(has('nvim'),
    \ {
    \   'for': g:completion_filetypes['deoplete'],
    \ })
" Vim {{{
Plug 'Shougo/neco-vim', Cond(has('nvim'),
    \ {
    \   'for': 'vim'
    \ })
" }}}
" Python (Jedi) {{{
Plug 'zchee/deoplete-jedi',
    \ Cond(has('nvim'),
    \ {
    \   'for': 'python',
    \ })
" }}}
" Typescript {{{
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
" }}}
" Fish {{{
Plug 'ponko2/deoplete-fish',                                    " Fish-shell completion for deoplete
    \ Cond(has('nvim'),
    \ {
    \   'for': 'fish',
    \ })
" }}}
" }}}
" YouCompleteMe {{{
Plug 'Valloric/YouCompleteMe',          Cond(!has('nvim'),
    \ {
    \   'do': 'python3 ~/git/python/shell/vimsync.py -y',
    \   'for': g:completion_filetypes['ycm'],
    \ })
" }}}
" }}}
" Status line {{{
" Airline {{{
Plug 'vim-airline/vim-airline',         Cond(has('nvim'))
Plug 'vim-airline/vim-airline-themes',  Cond(has('nvim'))
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
" Echodoc {{{
" TODO: Only execute for python/ts/js?
set cmdheight=1                                 " Add extra line for function definition
let g:echodoc#enable_at_startup = 1
set noshowmode
set shortmess+=c                                " Don't suppress echodoc with 'Match x of x'
" }}}
" Asyncrun {{{
let g:quickfix_mult = 0.40                                      " % of window height to take up
let g:quickfix_size = float2nr(g:quickfix_mult*winheight(0))    " Size of quickfix window used for ToggleQf() func
let g:asyncrun_open = g:quickfix_size                           " Show quickfix when executing command
let g:asyncrun_bell = 0                                         " Ring bell when job finished
let g:quickfix_run_scroll = 0                                   " Scroll when running code
let g:asyncrun_raw_output = 0                                   " Don't process errors on output
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

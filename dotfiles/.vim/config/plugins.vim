"   ____  _             _                 _
"  |  _ \| |_   _  __ _(_)_ __  _____   _(_)_ __ ___
"  | |_) | | | | |/ _` | | '_ \/ __\ \ / / | '_ ` _ \
"  |  __/| | |_| | (_| | | | | \__ \\ V /| | | | | | |
"  |_|   |_|\__,_|\__, |_|_| |_|___(_)_/ |_|_| |_| |_|
"                 |___/
"
" Common Vim/Neovim plugins

scriptencoding utf-8
" Helper functions/variables {{{1
" Vim-Plug Cond() {{{2
" Add conditions that aren't supported directly by vim-plug
function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

let g:vim_exists = executable('vim')

" Completion filetypes {{{2
let g:completion_filetypes = {
    \ 'deoplete':
    \   [
    \       'fish',
    \       'vim',
    \       'python',
    \   ],
    \ 'ycm':
    \   [
    \       'python',
    \       'javascript',
    \       'typescript',
    \       'cpp',
    \       'c',
    \       'go',
    \       'rust',
    \   ],
    \ 'coc':
    \   [
    \       'rust',
    \       'cpp',
    \       'c',
    \       'json',
    \       'go',
    \       'javascript',
    \       'typescript',
    \       'sh',
    \       'bash',
    \   ],
    \ }

" Plugin definitions {{{1
" BEGIN {{{2
call plug#begin('~/.vim/plugged')                               " Plugin Manager

" Editor features {{{2
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdtree',             Cond(1, { 'on': 'NERDTreeToggle' })
Plug 'scrooloose/nerdcommenter'
Plug 'mbbill/undotree',                 Cond(1, { 'on': 'UndotreeToggle' })
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf',
    \ Cond(1, {
    \   'dir': '~/.fzf',
    \   'do': './install --bin --no-key-bindings --no-update-rc',
    \ })
Plug 'junegunn/fzf.vim'
Plug 'ryanoasis/vim-devicons',          Cond(g:LL_nf)
Plug 'Shougo/echodoc'
Plug 'liuchengxu/vista.vim'
Plug 'tpope/vim-surround'
Plug 'chrisbra/Colorizer'

" Linting {{{2
Plug 'w0rp/ale'

" Formatting {{{2
Plug 'sbdchd/neoformat'

" Syntax highlighting {{{2
Plug 'HerringtonDarkholme/yats'
Plug 'gabrielelana/vim-markdown'
Plug 'dag/vim-fish'
Plug 'cespare/vim-toml'
Plug 'bfrg/vim-cpp-modern',             Cond(has('nvim'))

" Clang (compiled, vim only)
if g:vim_exists
    Plug 'jeaye/color_coded',
        \ Cond(!has('nvim'), {
        \   'for': [ 'c', 'cpp', 'c#' ],
        \   'do': 'rm -f CMakeCache.txt && cmake . && make && make install',
        \ })
endif

" Git {{{2
Plug 'airblade/vim-gitgutter',          Cond(0)
" Don't load if we're using coc (use coc-git instead)
autocmd vimrc FileType *
    \ if index(g:completion_filetypes['coc'], &filetype) < 0
    \ | call plug#load('vim-gitgutter')
    \ | endif

Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'

" Color themes {{{2
" Conditionally load themes based on env var
Plug 'arcticicestudio/nord-vim',        Cond(g:vim_base_color ==? 'nord')
Plug 'morhetz/gruvbox',                 Cond(g:vim_base_color ==? 'gruvbox')
Plug 'NLKNguyen/papercolor-theme',      Cond(g:vim_base_color ==? 'papercolor')
Plug 'nightsense/snow',                 Cond(g:vim_base_color ==? 'snow')

" Terminal/Code Execution {{{2
Plug 'skywind3000/asyncrun.vim'

" Snippets {{{2
Plug 'Shougo/neosnippet.vim',           Cond(has('nvim'))
Plug 'Shougo/neosnippet-snippets',      Cond(has('nvim'))
Plug 'honza/vim-snippets',              Cond(has('nvim'))

" Building {{{2
Plug 'vhdirk/vim-cmake',                Cond(1, { 'for': ['cpp', 'c'] })

" Code completion/Language server {{{2
" Coc {{{3
" Exclude completion on deoplete file types, so we can still use other features
" autocmd vimrc FileType *
"     \ if index(g:completion_filetypes['coc'], &filetype) < 0
"     \ | let b:coc_suggest_disable = 1

Plug 'neoclide/coc.nvim',
    \ Cond(has('nvim'),
    \ {
    \   'do': 'yarn install --frozen-lockfile',
    \   'for': g:completion_filetypes['coc'],
    \ })

function! Coc_post_update() abort
    call coc#util#install()
    if get(g:, 'coc_force_debug', 0) == 1
        " Build from source
        call coc#util#build()
    endif
endfunction

" Deoplete {{{3
Plug 'Shougo/deoplete.nvim',
    \ Cond(has('nvim'),
    \ {
    \   'for': g:completion_filetypes['deoplete'],
    \ })

" YouCompleteMe {{{3
if g:vim_exists
    Plug 'Valloric/YouCompleteMe',
        \ Cond(!has('nvim'),
        \ {
        \   'do': 'python3 ~/git/python/shell/vimsync.py -y',
        \   'for': g:completion_filetypes['ycm'],
        \ })
endif

" C {{{3
Plug 'tweekmonster/deoplete-clang2',
    \ Cond(has('nvim'))

" Vim {{{3
Plug 'Shougo/neco-vim',
    \ Cond(has('nvim'),
    \ {
    \   'for': 'vim'
    \ })

" Python (Jedi) {{{3
Plug 'zchee/deoplete-jedi',
    \ Cond(has('nvim'),
    \ {
    \   'for': 'python',
    \ })

" Fish {{{3
Plug 'ponko2/deoplete-fish',
    \ Cond(has('nvim'),
    \ {
    \   'for': 'fish',
    \ })

" Go {{{3
Plug 'zchee/deoplete-go',
    \ Cond(has('nvim'),
    \ {
    \   'do': 'make',
    \ })

Plug 'mdempsky/gocode',
    \ Cond(has('nvim'),
    \ {
    \   'rtp': 'vim',
    \   'do': '~/.vim/plugged/gocode/vim/symlink.sh'
    \ })

" Status line {{{2
" Vim (Airline) {{{3
if g:vim_exists
    Plug 'vim-airline/vim-airline',         Cond(!has('nvim'))
    Plug 'vim-airline/vim-airline-themes',  Cond(!has('nvim'))
endif

" Neovim (Lightline/Eleline) {{{3
let g:nvim_statusbar = 'eleline'
let g:use_lightline = get(g:, 'nvim_statusbar', '') ==# 'lightline'
let g:use_eleline =   get(g:, 'nvim_statusbar', '') ==# 'eleline'
let g:eleline_background = 234

Plug 'comfortablynick/eleline.vim',     Cond(has('nvim') && g:use_eleline)
Plug 'itchyny/lightline.vim',           Cond(has('nvim') && g:use_lightline)
Plug 'maximbaz/lightline-ale',          Cond(has('nvim') && g:use_lightline)
Plug 'mgee/lightline-bufferline',       Cond(has('nvim') && g:use_lightline)

" Tmux {{{2
Plug 'christoomey/vim-tmux-navigator',  Cond(!empty($TMUX_PANE))
Plug 'christoomey/vim-tmux-runner',
    \ Cond(!empty($TMUX_PANE),
    \ {
    \   'on':
    \     [
    \       'VtrSendCommandToRunner',
    \       'VtrOpenRunner',
    \       'VtrSendCommand',
    \       'VtrSendFile',
    \       'VtrKillRunner',
    \       'VtrAttachToPane',
    \     ]
    \ })

" END {{{2
call plug#end()

" Plugin configuration {{{1
" ALE (Asynchronus Linting Engine)  {{{2
" Main options {{{3
let g:ale_close_preview_on_insert = 1                           " Close preview window in INSERT mode
let g:ale_cursor_detail = 0                                     " Open preview window when focusing on error
let g:ale_echo_cursor = 1                                       " Either this or ale_cursor_detail need to be set to 1
let g:ale_cache_executable_check_failures = 1                   " Have to restart vim if adding new providers
let g:ale_lint_on_text_changed = 'never'                        " Don't lint while typing (too distracting)
let g:ale_lint_on_insert_leave = 1                              " Lint after leaving insert
let g:ale_lint_on_enter = 0                                     " Lint when opening file
let g:ale_list_window_size = 5                                  " Show # of lines of errors
let g:ale_open_list = 0                                         " Show quickfix list
let g:ale_set_loclist = 0                                       " Show location list
let g:ale_set_quickfix = 1                                      " Show quickfix list with errors
let g:ale_fix_on_save = 1                                       " Apply fixes when saving
let g:ale_echo_msg_error_str = 'E'                              " Error string prefix
let g:ale_echo_msg_warning_str = 'W'                            " Warning string prefix
let g:ale_echo_msg_format = '[%linter%] %s (%severity%%: code%)'
let g:ale_sign_column_always = 0                                " Always show column on left side, even with no errors/warnings
let g:ale_completion_enabled = 0                                " Enable ALE completion if no other completion engines
let g:ale_virtualtext_cursor = 1                                " Enable Neovim's virtualtext support
let g:ale_virtualtext_prefix = ' ➜ '                           " Prefix the virtualtext message
let g:ale_virtualenv_dir_names = [
    \   '.env',
    \   'dev',
    \   ]

" Linters/fixers {{{3
" 'go': [ 'gometalinter', 'golint' ],

let g:ale_linters = {
    \ 'python': [
    \   'flake8',
    \   'mypy',
    \   'pydocstyle',
    \  ],
    \ 'cpp': [],
    \ 'c': [
    \   'clangtidy',
    \   'gcc',
    \  ],
    \ 'go': [],
    \ 'rust': [],
    \ 'sh': [
    \   'shellcheck'
    \  ],
    \ }

let g:ale_fixers = {
    \ '*': [
    \   'remove_trailing_lines',
    \   'trim_whitespace',
    \  ],
    \ 'python': [
    \   'black',
    \   'isort',
    \  ],
    \ 'typescript': [
    \   'prettier',
    \  ],
    \ 'javascript': [
    \   'prettier',
    \  ],
    \ 'go': [
    \   'goimports',
    \  ],
    \ 'sh': [
    \   'shfmt',
    \  ],
    \ 'zsh': [
    \   'shfmt',
    \  ],
    \ 'cpp': [
    \   'clang-format',
    \  ],
    \ 'c': [
    \   'clang-format',
    \  ],
    \ 'rust': [
    \   'rustfmt',
    \  ],
    \ 'cmake': [
    \   'cmakeformat',
    \  ],
    \ }

" Linter/fixer options {{{3
let g:ale_python_flake8_options = '--max-line-length 100  --ignore E203,E302,W503'
let g:ale_python_mypy_ignore_invalid_syntax = 1
let g:ale_python_mypy_options = '--ignore-missing-imports'
let g:ale_javascript_prettier_options = '--trailing-comma es5 --tab-width 4 --endOfLine lf'
let g:ale_typescript_prettier_options = g:ale_javascript_prettier_options
let g:ale_go_gometalinter_options = '--fast --aggregate --cyclo-over=20'
let g:ale_rust_rls_toolchain = 'stable'
let g:ale_c_gcc_options = '-std=gnu11 -Wall -Wextra'
let g:ale_cmake_cmakeformat_options = '--config-file $HOME/.config/cmake/cmake-format.py'
let g:ale_cmake_cmakelint_options = '--config=$HOME/.config/cmake/cmakelintrc'

" Neoformat {{{2
" Global Settings
let g:neoformat_run_all_formatters = 1                          " By default, stops after first formatter succeeds

" Basic formatting when no filetype is found
let g:neoformat_basic_format_align = 1                          " Enable formatting
let g:neoformat_basic_format_retab = 1                          " Enable tab -> spaces
let g:neoformat_basic_format_trim = 1                           " Trim trailing whitespace

" Filetype-specific formatters
let g:neoformat_enabled_python = [
    \   'black',
    \   'isort',
    \ ]
let g:neoformat_enabled_typescript = [ 'prettier' ]
let g:neoformat_enabled_javascript = [ 'prettier' ]
" TODO: add options to match Python prettier formatter on iPad
" - Move variable declarations to new line
let g:neoformat_typescript_prettier = {
    \ 'exe': 'prettier',
    \ 'args': [
    \   '--tab-width 4',
    \   '--trailing-comma es5',
    \   '--stdin',
    \   '--stdin-filepath',
    \   '"%:p"',
    \ ],
    \ 'stdin': 1,
    \ }

let g:neoformat_cmake_cmakeformat = {
    \ 'exe': 'cmake-format',
    \ 'args': ['--config-file $HOME/.config/cmake/cmake-format.py'],
    \ }
" Same options for javascript
let g:neoformat_javascript_prettier = g:neoformat_typescript_prettier

let g:neoformat_enabled_go = [ 'goimports' ]

" NERDTree {{{2
let NERDTreeHighlightCursorline = 1
let NERDTreeIgnore = [
    \ '\.pyc$',
    \ '^__pycache__$',
    \ '.vscode',
    \ ]
let NERDTreeShowHidden = 1
let NERDTreeQuitOnOpen = 1

" NERD Commenter
let g:NERDSpaceDelims = 1                       " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1                   " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'                 " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1                    " Set a language to use its alternate delimiters by default
let g:NERDCommentEmptyLines = 1                 " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1            " Enable trimming of trailing whitespace when uncommenting
let g:NERDToggleCheckAllLines = 1               " Enable NERDCommenterToggle to check all selected lines is commented or not

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = {
    \ 'c':
    \   { 'left': '/**', 'right': '*/' },
    \ 'json':
    \   { 'left': '//' },
    \ }

" Echodoc {{{2
" TODO: Only execute for python/ts/js?
let g:echodoc#enable_at_startup = 1
let g:ecodoc#type = 'echo'                   " virtual: virtualtext; echo: use command line echo area
set cmdheight=1                                 " Add extra line for function definition
set noshowmode
set shortmess+=c                                " Don't suppress echodoc with 'Match x of x'

" Neosnippet {{{2
if exists('g:loaded_neosnippet')
    let g:neosnippet#enable_completed_snippet = 1
    autocmd vimrc CompleteDone * call neosnippet#complete_done()
endif

" AsyncRun {{{2
let g:asyncrun_open = 10                                        " Show quickfix when executing command
let g:asyncrun_bell = 0                                         " Ring bell when job finished
let g:quickfix_run_scroll = 0                                   " Scroll when running code
let g:asyncrun_raw_output = 0                                   " Don't process errors on output
let g:asyncrun_save = 0                                         " Save file before running

" CMake {{{2
let g:cmake_ycm_symlinks = 0                                    " Symlink json file for YouCompleteMe

" Undotree {{{2
let g:undotree_WindowLayout = 4                                 " Show tree on right + diff below

" Airline {{{2
let g:airline_extensions = [
    \ 'tabline',
    \ 'ale',
    \ 'branch',
    \ 'hunks',
    \ 'wordcount',
    \ 'virtualenv',
    \ 'tagbar',
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
let g:airline_highlighting_cache = 1

" Airline Tabline
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 0

" Indentline {{{2
let g:indentLine_setConceal = 1                 " Don't change conceal settings
let g:indentLine_showFirstIndentLevel = 0
let g:indentLine_char = '│'

" LanguageClient {{{2
let g:LanguageClient_serverCommands = {
    \ }
let g:LanguageClient_completionPreferTextEdit = 0
" » ◊ ‼
let g:LanguageClient_diagnosticsDisplay =
    \ {
    \     1: {
    \         'name': 'Error',
    \         'texthl': 'ALEError',
    \         'signText': '✘',
    \         'signTexthl': 'Error',
    \         'virtualTexthl': 'Error',
    \     },
    \     2: {
    \         'name': 'Warning',
    \         'texthl': 'ALEWarning',
    \         'signText': '‼',
    \         'signTexthl': 'ALEWarningSign',
    \         'virtualTexthl': 'Todo',
    \     },
    \     3: {
    \         'name': 'Information',
    \         'texthl': 'ALEInfo',
    \         'signText': '»',
    \         'signTexthl': 'ALEInfoSign',
    \         'virtualTexthl': 'Todo',
    \     },
    \     4: {
    \         'name': 'Hint',
    \         'texthl': 'ALEInfo',
    \         'signText': '⮞',
    \         'signTexthl': 'ALEInfoSign',
    \         'virtualTexthl': 'Todo',
    \     },
    \ }
let g:LanguageClient_changeThrottle = 1
let g:LanguageClient_diagnosticsEnable = 0

" Deoplete {{{2
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
autocmd vimrc CompleteDone * if pumvisible() == 0 | pclose | endif

" Nvim Typescript {{{2
" let g:nvim_typescript#type_info_on_hold = 1

" YouCompleteMe {{{2
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

" Tagbar {{{2
let g:tagbar_autoclose = 1                                      " Autoclose tagbar after selecting tag
let g:tagbar_autofocus = 1                                      " Move focus to tagbar when opened
let g:tagbar_compact = 1                                        " Eliminate help msg, blank lines
let g:tagbar_autopreview = 0                                    " Open preview window with selected tag details
let g:tagbar_sort = 0                                           " Sort tags alphabetically vs. in file order

" Vim Tmux Runner {{{2
let g:use_term = 0                                              " Use term instead of Vtr/AsyncRun
let g:run_code_with = 'term'
let g:VtrStripLeadingWhitespace = 0                             " Useful for Python to avoid messing up whitespace
let g:VtrClearEmptyLines = 0                                    " Disable clearing if blank lines are relevant
let g:VtrAppendNewline = 1                                      " Add newline to multiline send
let g:VtrOrientation = 'h'                                      " h/v split
let g:VtrPercentage = 40                                        " Percent of tmux window the runner pane with occupy
let g:VtrInitialCommand = 'LS_AFTER_CD=0'                       " Turn off auto 'ls after cd'

let g:vtr_filetype_runner_overrides = {
    \ 'go': 'go run *.go',
    \ 'rust': 'cargo run',
    \ 'cpp': 'build/gitpr',
    \ }

" Syntax highlighting {{{2
" C++ {{{3
" Disable function highlighting (affects both C and C++ files)
let g:cpp_no_function_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group `Statement`
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

" Enable highlighting of named requirements (C++20 library concepts)
let g:cpp_named_requirements_highlight = 1

" clever-f {{{2
let g:clever_f_smart_case = 1                                   " Ignore case if lowercase

" vista {{{2
let g:vista#renderer#icons = {
\    'func': 'ƒ',
\    'function': 'ƒ',
\    'var': 'ʋ',
\    'variable': 'ʋ',
\    'const': 'c',
\    'constant': 'c',
\    'method': '𝑚',
\    'package': 'p',
\    'packages': 'p',
\    'enum': 'e',
\    'enumerator': 'e',
\    'module': 'M',
\    'modules': 'M',
\    'type': '𝑡',
\    'typedef': '𝑡',
\    'types': '𝑡',
\    'field': 'f',
\    'fields': 'f',
\    'macro': 'ɱ',
\    'macros': 'ɱ',
\    'map': '⇶',
\    'class': 'c',
\    'augroup': 'a',
\    'struct': 's',
\    'union': 'u',
\    'member': 'm',
\    'target': 't',
\    'property': 'p',
\    'interface': 'I',
\    'namespace': 'n',
\    'subroutine': 'ƒ',
\    'implementation': 'I',
\    'typeParameter': '𝑡',
\    'default': 'd',
\}
let g:vista_close_on_jump = 1

" vim:set fdl=1:

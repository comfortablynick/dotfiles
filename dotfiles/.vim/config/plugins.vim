" Plugins using dein plugin manager
" Dein init {{{
set nocompatible
filetype plugin indent off
syntax off

if has('vim_starting')
    exec "set runtimepath+=".expand("$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim/")
endif

" Install Dein if needed
if !filereadable(expand('$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim/README.md'))
  echo "Installing Dein..."
  echo ""
  silent !mkdir -p $XDG_DATA_HOME/dein
  silent !git clone https://github.com/Shougo/dein.vim $XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim/
  silent !cd $XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim/
  silent !sh ./installer.sh $XDG_DATA_HOME/dein
  echo "Dein install completed."
endif
" }}}
" Plugins {{{
if dein#load_state(expand('$XDG_DATA_HOME/dein'))
    call dein#begin(expand('$XDG_DATA_HOME/dein'))
    " Common Plugins {{{
    " Plugin manager
    call dein#add(expand('$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim'))

    " Editor features
    call dein#add('airblade/vim-gitgutter')
    call dein#add('scrooloose/nerdtree',
        \ {
        \  'on_cmd': 'NERDTreeToggle'
        \ })
    call dein#add('ryanoasis/vim-devicons',
        \ {
        \  'if': '$NERD_FONTS != 0'
        \ })
    call dein#add('~/.fzf')
    call dein#add('junegunn/fzf.vim')
    call dein#add('Shougo/echodoc',
        \ {
        \  'build': 'nvim -s +"call dein#remote_plugins()"'
        \ })

    " Linting
    call dein#add('w0rp/ale')

    " Color themes
    call dein#add('morhetz/gruvbox',
        \ {
        \  'merged': 0
        \ })
    call dein#add('arcticicestudio/nord-vim',
        \ {
        \  'merged': 0
        \ })
    call dein#add('NLKNguyen/papercolor-theme',
        \ {
        \  'merged': 0
        \ })
    call dein#add('nightsense/snow',
        \ {
        \  'merged': 0
        \ })

    " Syntax highlighting
    call dein#add('HerringtonDarkholme/yats',
        \ {
        \  'on_ft': 'typescript'
        \ })
    call dein#add('gabrielelana/vim-markdown',
        \ {
        \  'on_ft': 'markdown'
        \ })
    call dein#add('Soares/fish.vim',
        \ {
        \  'on_ft': 'fish'
        \ })

    " Formatting
    call dein#add('ambv/black',
        \ {
        \  'on_ft': 'python',
        \  'merged': 0
        \ })

    " Git
    call dein#add('junegunn/gv.vim')
    call dein#add('tpope/vim-fugitive')

    " Executing
    call dein#add('skywind3000/asyncrun.vim',
        \ {
        \  'lazy': 1
        \ })
    " }}}
    " Neovim Plugins {{{
    if has('nvim')
        call dein#add('Shougo/deoplete.nvim',
            \ {
            \  'build': 'nvim -s +"call dein#remote_plugins()"',
            \ })
        call dein#add('zchee/deoplete-jedi',
            \ {
            \  'on_ft': 'python'
            \ })
        call dein#add('mhartington/nvim-typescript',
            \ {
            \  'build': './install.sh',
            \  'on_ft': ['typescript', 'tsx']
            \ })
        call dein#add('Shougo/neco-vim',
            \ {
            \  'on_ft': 'vim'
            \ })
        call dein#add('vim-airline/vim-airline')
        call dein#add('vim-airline/vim-airline-themes')
    endif
    " }}}
    " Vim Plugins {{{
    if !has('nvim')
        set rtp+=/usr/local/lib/python3.7/site-packages/powerline/bindings/vim
        call dein#add('itchyny/lightline.vim')
        call dein#add('maximbaz/lightline-ale')
        call dein#add('Valloric/YouCompleteMe',
          \ {
          \  'build': './install.py',
          \  'merged': 0
          \ })
    endif
    " }}}
    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
	call dein#install()
endif

filetype plugin indent on
syntax enable
" }}}
" Common Configuration {{{
" Ale linter
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

" Ale linter settings
let g:python_flake8_options = {
    \ '--max-line-length': 88
    \ }

" NERDTree
let NERDTreeHighlightCursorline = 1                             " Increase visibility of line
let NERDTreeIgnore = [
    \ '\.pyc$',
    \ '^__pycache__$',
    \ '.vscode'
    \ ]
let NERDTreeShowHidden = 1                                      " Show dotfiles

" Black
let g:black_virtualenv = "~/.env/black"                         " Black virtualenv location (custom)

" Asyncrun
let g:asyncrun_open = 6                                         " Show quickfix when executing command
let g:asyncrun_bell = 1                                         " Ring bell when job finished

" Undotree
let g:undotree_WindowLayout = 4                                 " Show tree on right + diff below

" Echodoc
" TODO: Only execute for python/ts/js?
set noshowmode                                                  " Don't duplicate mode in echo area
set cmdheight=1                                                 " Height of echo area
let g:echodoc_enable_at_startup = 1                             " Enable by default
set shortmess+=c                                                " Don't suppress echodoc with 'Match x of x'
" }}}
" Neovim Configuration {{{
if has('nvim')
    " Airline
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

    " Deoplete
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#sources#jedi#show_docstring = 1
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
endif
" }}}
" Vim Configuration {{{
if !has('nvim')
    " YouCompleteMe
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
endif
" }}}

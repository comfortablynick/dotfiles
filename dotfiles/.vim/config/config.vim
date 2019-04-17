"                    __ _             _
"    ___ ___  _ __  / _(_) __ ___   _(_)_ __ ___
"   / __/ _ \| '_ \| |_| |/ _` \ \ / / | '_ ` _ \
"  | (_| (_) | | | |  _| | (_| |\ V /| | | | | | |
"   \___\___/|_| |_|_| |_|\__, (_)_/ |_|_| |_| |_|
"                         |___/
" General Configuration
" Application {{{1
set shell=/bin/bash                                             " Use bash to execute commands instead of sh
set noswapfile                                                  " Don't create freaking swap files
set ttyfast                                                     " Terminal acceleration
set autoread                                                    " Detect when a file has been changed outside of vim
filetype plugin on                                              " Allow loading .vim files for different filetypes

if has('nvim')
    " Neovim Only
    set inccommand=split                                        " Live substitution
    let g:python_host_prog = $NVIM_PY2_DIR                      " Python2 binary
    let g:python3_host_prog = $NVIM_PY3_DIR                     " Python3 binary
    let &shadafile =
        \ expand('$XDG_DATA_HOME/nvim/shada/main.shada')        " Location of nvim replacement for viminfofile
else
    " Vim Only
    set pyxversion=3                                            " Use Python3 for pyx
    let g:python3_host_prog = '/usr/local/bin/python3.7'
endif

" General {{{1
syntax enable                                                   " Syntax highlighting on
colorscheme default                                             " Def colors (overwritten by theme.vim)
set hidden                                                      " Don't unload hidden buffers
set fileformat=unix                                             " Always use LF and not CRLF
set encoding=utf-8                                              " Default to unicode
set termencoding=utf-8                                          " Unicode
set synmaxcol=200                                               " Don't try to highlight if line > 200 chr
set laststatus=2                                                " Always show statusline
set showtabline=2                                               " Always show tabline
set visualbell                                                  " Visual bell instead of audible
set nowrap                                                      " Text wrapping mode
set noshowmode                                                  " Hide default mode text (e.g. -- INSERT -- below statusline)
set clipboard=unnamed                                           " Use system clipboard
set cursorline                                                  " Show line under cursor's line (check autocmds)
set ruler                                                       " Show line info
set showmatch                                                   " Show matching pair of brackets (), [], {}
set updatetime=300                                              " Update more often (helps GitGutter)
set signcolumn=yes                                              " Always show; keep appearance consistent
set scrolloff=10                                                " Lines before/after cursor during scroll
set ttimeoutlen=10                                              " How long in ms to wait for key combinations (if used)
set timeoutlen=200                                              " How long in ms to wait for key combinations (if used)
set mouse=a                                                     " Use mouse in all modes (allows mouse scrolling in tmux)
set lazyredraw                                                  " Don't redraw screen when not needed
set nostartofline                                               " Don't move to start of line with j/k
set conceallevel=1                                              " Enable concealing, if defined
set concealcursor=                                              " Don't conceal when cursor goes to line
set completeopt+=preview                                        " Enable preview option for completion
set virtualedit=onemore                                         " Allow cursor to extend past line

" Folds {{{1
set foldenable                                                  " Enable folds by default
set foldnestmax=5                                               " Max nested levels (default=20)

" Indents {{{1
set expandtab                                                   " Expand tab to spaces
set smartindent                                                 " Attempt smart indenting
set autoindent                                                  " Attempt auto indenting
set shiftwidth=4                                                " Indent width in spaces
set backspace=2                                                 " Backspace behaves as expected
let g:vim_indent_cont = &shiftwidth                             " Indent after \ in Vim script

" Search & replace {{{1
set ignorecase                                                  " Ignore case while searching
set smartcase                                                   " Case sensitive if uppercase in pattern
set incsearch                                                   " Move cursor to matched string
set nohlsearch                                                  " Don't highlight search results
set magic                                                       " Magic escaping for regex

" use ripgrep as grepprg
if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --no-ignore-vcs
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Undo {{{1
set undodir=~/.vim/undo                                         " Undo file directory
set undofile                                                    " Enable persistent undo

" Windows/Splits {{{1
set splitright                                                  " Split right instead of left
set splitbelow                                                  " Split below instead of above
let g:window_width = &columns                                   " Initial window size (use to determine if on iPad)

" Line numbers {{{1
set number                                                      " Show linenumbers
set relativenumber                                              " Show relative numbers (hybrid with `number` enabled)

" Terminal client compatibility {{{1
" Defaults: turn all fonts and colors ON {{{2
let g:LL_pl = 1
let g:LL_nf = 1
set termguicolors

" SSH: remove background to try to work better with iOS SSH apps {{{2
if $VIM_SSH_COMPAT == 1
    hi Normal guibg=NONE ctermbg=NONE
    hi nonText guibg=NONE ctermbg=NONE
    let g:LL_nf = 0
    set notermguicolors
endif

" FONTS: check env vars to see if we need to turn off fancy fonts {{{2
if ! empty($POWERLINE_FONTS) && $POWERLINE_FONTS == 0
    " We can turn off both, since NF are a superset of PL fonts
    let g:LL_nf = 0
    let g:LL_pl = 0
elseif ! empty($NERD_FONTS) && $NERD_FONTS == 0
    " Disable NF but keep PL fonts (iOS SSH apps, etc.)
    let g:LL_nf = 0
    let g:LL_pl = 1
endif

" TMUX: make it work with termguicolors {{{2
if &term =~# '^screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Get color theme from env var {{{2
function! GetColorTheme() abort
    return has('nvim') ?
        \ !empty('$NVIM_COLOR') ? $NVIM_COLOR : 'papercolor-dark' :
        \ !empty('$VIM_COLOR') ? $VIM_COLOR : 'gruvbox-dark'
endfunction
let g:vim_color = GetColorTheme()

" g:vim_base_color: 'nord-dark' -> 'nord'
let g:vim_base_color = substitute(
    \ g:vim_color,
    \ '-dark\|-light',
    \ '',
    \ '')

" g:vim_color_variant: 'nord-dark' -> 'dark'
let g:vim_color_variant = substitute(
    \ g:vim_color,
    \ g:vim_base_color . '-',
    \ '',
    \ '')

" Increase timeoutlen {{{2
if $TMUX_SESSION ==? 'ios'
    set timeoutlen=400
endif

" Cursor {{{1
" set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
"     \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
"     \,sm:block-blinkwait175-blinkoff150-blinkon175

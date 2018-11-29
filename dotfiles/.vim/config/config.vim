"                    __ _             _
"    ___ ___  _ __  / _(_) __ ___   _(_)_ __ ___
"   / __/ _ \| '_ \| |_| |/ _` \ \ / / | '_ ` _ \
"  | (_| (_) | | | |  _| | (_| |\ V /| | | | | | |
"   \___\___/|_| |_|_| |_|\__, (_)_/ |_|_| |_| |_|
"                         |___/
" General Configuration
" Application {{{
set noswapfile                                                  " Don't create freaking swap files
set ttyfast                                                     " Terminal acceleration
set autoread                                                    " Detect when a file has been changed outside of vim
filetype plugin on                                              " Allow loading .vim files for different filetypes

if has('nvim')
    " Neovim Only
    set inccommand=split                                        " Live substitution
    let g:python_host_prog = $NVIM_PY2_DIR                      " Python2 binary
    let g:python3_host_prog = $NVIM_PY3_DIR                     " Python3 binary
else
    " Vim Only
    set pyxversion=3                                            " Use Python3 for pyx
    let g:python3_host_prog = '/usr/local/bin/python3.7'
endif
" }}}
" General {{{
syntax enable                                                   " Syntax highlighting on
colorscheme slate                                               " Def colors (overwritten by theme.vim)
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
set cursorline                                                  " Show line under cursor's line
set ruler                                                       " Show line info
set showmatch                                                   " Show matching pair of brackets (), [], {}
set updatetime=100                                              " Update more often (helps GitGutter)
set signcolumn=yes                                              " Always show; keep appearance consistent
set scrolloff=10                                                " Lines before/after cursor during scroll
set ttimeoutlen=10                                              " How long in ms to wait for key combinations
set mouse=a                                                     " Use mouse in all modes (allows mouse scrolling in tmux)
set lazyredraw                                                  " Don't redraw screen when not needed
set nostartofline                                               " Don't move to start of line with j/k
" }}}
" Folds {{{
set foldenable                                                  " Enable folds by default
set foldnestmax=5                                               " Max nested levels (default=20)
" }}}
" Indents {{{
set expandtab                                                   " Expand tab to spaces
set smartindent                                                 " Attempt smart indenting
set autoindent                                                  " Attempt auto indenting
set shiftwidth=4                                                " Indent width in spaces
set backspace=2                                                 " Backspace behaves as expected
let g:vim_indent_cont = &shiftwidth                             " Indent after \ in Vim script
" }}}
" Search & replace {{{
set ignorecase                                                  " Ignore case while searching
set smartcase                                                   " Case sensitive if uppercase in pattern
set incsearch                                                   " Move cursor to matched string
set hlsearch                                                    " Highlight search results
set magic                                                       " Magic escaping for regex
" }}}
" Undo {{{
set undodir=~/.vim/undo                                         " Undo file directory
set undofile                                                    " Enable persistent undo
" }}}
" Window Split {{{
set splitright                                                  " Split right instead of left
set splitbelow                                                  " Split below instead of above
" }}}
" Line numbers {{{
set number                                                      " Show linenumbers
set relativenumber                                              " Show relative numbers (hybrid with `number` enabled)

" Toggle to number mode depending on vim mode
" INSERT:       Turn off relativenumber while writing code
" NORMAL:       Turn on relativenumber for easy navigation
" NO FOCUS:     Turn off relativenumber (testing code, etc.)
" QuickFix:     Turn off relativenumber (running code)
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
  autocmd FileType qf if &nu | set nornu | endif
augroup END
" }}}
" Theme Compatibility {{{
" Defaults: turn all fonts and colors ON {{{
let g:LL_pl = 1
let g:LL_nf = 1
set termguicolors
" }}}
" SSH: remove background to try to work better with iOS SSH apps {{{
if $VIM_SSH_COMPAT == 1
    hi Normal guibg=NONE ctermbg=NONE
    hi nonText guibg=NONE ctermbg=NONE
    let g:LL_nf = 0
    set notermguicolors
endif
" }}}
" FONTS: check env vars to see if we need to turn off nerd/powerline fonts {{{
if ! empty($POWERLINE_FONTS) && $POWERLINE_FONTS == 0
    " We can turn off both, since NF are a superset of PL fonts
    let g:LL_nf = 0
    let g:LL_pl = 0
elseif ! empty($NERD_FONTS) && $NERD_FONTS == 0
    " Disable NF but keep PL fonts (iOS SSH apps, etc.)
    let g:LL_nf = 0
    let g:LL_pl = 1
endif
" }}}
" TMUX: make it work with termguicolors {{{
if &term =~# '^screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
" }}}
" Get color theme from env var {{{
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
" }}}
" }}}

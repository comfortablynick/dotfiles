"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
" (_)_/ |_|_| |_| |_|_|  \___|
"
" Cursor shape (set to match Neovim default)
"
" Number key
" --------------------------
" 1 - blinking block
" 2 - fixed block (default)
" 3 - blinking underscore
" 4 - fixed underscore
" 5 - blinking pipe bar
" 6 - fixed pipe bar
let &t_SI = "\<esc>[6 q" " Insert mode
let &t_SR = "\<esc>[4 q" " Replace mode
let &t_EI = "\<esc>[2 q" " Normal mode

" Set sequences for RGB terminal colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

set noswapfile           " Swap files if vim quits without saving
set autoread             " Detect when a file has been changed outside of vim
set backup
set undofile
set backupdir=~/.vim/backup//
set wildmenu
set wildoptions=pum
set pyxversion=3
set undodir=~/.vim/undo//

let s:dirs = [&backupdir, &undodir]
for s:dir in s:dirs
    if filewritable(s:dir) != 2
        call mkdir(s:dir, 'p')
    endif
endfor

set background=dark
set encoding=utf-8                           " Default to unicode
scriptencoding utf-8                         " Encoding used in sourced script
set termguicolors                            " Use true color
set shell=/bin/sh                            " Use posix-compatible shell
set hidden                                   " Don't unload hidden buffers
set fileformat=unix                          " Always use LF and not CRLF
set history=5000                             " # of history entries (max 10000)
set synmaxcol=300                            " Don't try to highlight if line > N
set laststatus=2                             " Always show statusline
set showtabline=2                            " Always show tabline
set visualbell                               " Visual bell instead of audible
set nowrap                                   " Text wrapping mode
set showmode                                 " Show default mode text (e.g. -- INSERT -- below statusline)
set shortmess+=c                             " Don't show 'Match x of x'
set clipboard=unnamed                        " Use system clipboard
set nocursorline                             " Show line under cursor's line (check autocmds)
set ruler                                    " Show Line position (not needed if using a statusline plugin)
set showmatch                                " Show matching pair of brackets (), [], {}
set updatetime=700                           " Controls CursorHold timing and swap file write time
set signcolumn=yes                           " Display signcolumn or use numbercolumn
set scrolloff=10                             " Lines before/after cursor during scroll
set timeoutlen=300                           " How long in ms to wait for key combinations (if used)
set mouse=a                                  " Use mouse in all modes (allows mouse scrolling in tmux)
set nostartofline                            " Don't move to start of line with j/k
set conceallevel=1                           " Enable concealing, if defined
set concealcursor=                           " Enable concealing when cursor on line in these modes
set virtualedit=onemore                      " Allow cursor to extend past line
set wildignore+=__pycache__,.mypy_cache,.git " Ignore these file globs in wildmenu
set list                                     " Show extra characters
set listchars=tab:▸\ ,nbsp:␣,trail:·         " Define chars for 'list'
set title                                    " Set window title

set dictionary+=/usr/share/dict/words-insane " Dictionary file for dict completion
set foldenable                               " Enable folds by default
set foldnestmax=5                            " Max nested levels (default=20)

set expandtab                                " Expand tab to spaces
set smartindent                              " Attempt smart indenting
set autoindent                               " Attempt auto indenting
set tabstop=4                                " How many spaces a tab is worth
set shiftwidth=0                             " Columns of whitespace per indent (0 = &tabstop)
set backspace=2                              " Backspace behaves as expected
set cmdwinheight=10                          " Height of cmdwin (`q:` or <C-f> in cmdline)
set splitright                               " Split right instead of left
set splitbelow                               " Split below instead of above
set number                                   " Show linenumbers
set relativenumber                           " Show relative numbers (hybrid with `number` enabled)
set noignorecase                             " Ignore case while searching
set smartcase                                " Case sensitive if uppercase in pattern
set incsearch                                " Move cursor to matched string
set magic                                    " Magic escaping for regex

let g:window_width = &columns                " Initial window size (use to determine if on iPad)
let g:mapleader = ','                        " Leader for maps (default is '\')
let g:c_syntax_for_h = 1                     " Treat .h files as c, not cpp
let g:vimsyn_embed = 'lP'                    " Enable embedded lua/Python
let g:python3_host_prog = 'python3'

" Check for grep alternatives and use if present
if executable('ugrep')
    set grepprg=ugrep\ -RInkju.\ --tabs=1
    set grepformat=%f:%l:%c:%m,%f+%l+%c+%m,%-G%f\\\|%l\\\|%c\\\|%m
elseif executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --no-ignore-vcs
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif


" Disable Vim default plugins {{{2
let g:loaded_gzip = 1
let g:loaded_tarPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_html_plugin = 1
let g:loaded_rrhelper = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimballPlugin = 1

" Disable providers {{{2
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python_provider = 0

silent! packadd! matchit


" Maps {{{1
" General {{{2
nnoremap U <C-r>
nnoremap qq :x<CR>
nnoremap qqq :q!<CR>
nnoremap QQ ZQ
nnoremap Y y$

" Remap ; to : {{{2
nnoremap ; :
xnoremap ; :
onoremap ; :
nnoremap g: g;
nnoremap @; @:
nnoremap q; q:
xnoremap q; q:

" Run the last command
nnoremap <Leader><Leader>c :<Up>

" Clears hlsearch after doing a search, otherwise <CR>
nnoremap <expr> <CR> {-> v:hlsearch ? ":nohlsearch\<CR>" : "\<CR>"}()
tnoremap <buffer><silent> <Esc> <C-\><C-n><CR>:bw!<CR>

" Use kj to escape insert mode
inoremap kj <Esc>`^

" Indent/outdent {{{2
vnoremap <Tab>   <Cmd>normal! >gv<CR>
vnoremap <S-Tab> <Cmd>normal! <gv<CR>

" `CTRL+{h,j,k,l}` to navigate in normal mode {{{2
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-p> <C-w>p

" Delete window to the left/below/above/to the right with d<C-h/j/k/l> {{{2
nnoremap d<C-j> <C-w>j<C-w>c
nnoremap d<C-k> <C-w>k<C-w>c
nnoremap d<C-h> <C-w>h<C-w>c
nnoremap d<C-l> <C-w>l<C-w>c

" Override vim-impaired tagstack mapping {{{2
nnoremap <silent> [t <Cmd>tabprevious<CR>
nnoremap <silent> ]t <Cmd>tabnext<CR>

" Buffer navigation {{{1
nnoremap <Tab>      <Cmd>bnext<CR>
nnoremap <S-Tab>    <Cmd>bprevious<CR>
nnoremap <Leader>w  <Cmd>update\|bwipeout<CR>

" Fold
nnoremap <Space> <Cmd>silent! exe 'normal! za'<CR>
nnoremap za zA

" Command line {{{1
" %% -> cwd
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" Plugins {{{1
" Install vim-plug {{{2
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plugin list {{{2
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary'
Plug 'NLKNguyen/papercolor-theme'
Plug 'justinmk/vim-dirvish'

let g:PaperColor_Theme_Options = {
    \   'theme': {
    \     'default': {
    \       'allow_bold': 1,
    \       'allow_italic': 1,
    \     }
    \   }
    \ }

" List ends here; plugins become available
call plug#end()

" Install missing plugins and reload
if !empty(filter(values(g:plugs), {_,v->!isdirectory(v.dir)}))
    PlugInstall --sync
    quit " Close vim-plug window
    source $MYVIMRC
endif

" Filetype/Syntax {{{1
silent! colorscheme PaperColor
filetype plugin on       " Allow loading .vim files for different filetypes
syntax enable            " Syntax highlighting on

" vim:fdm=marker fdl=1:

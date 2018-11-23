" VIM / NEOVIM GENERAL CONFIG ====================
" Application {{{
set nocompatible                        " Ignore compatibility issues with Vi
set noswapfile                          " Don't create freaking swap files
set ttyfast                             " Terminal acceleration
filetype plugin on                      " Allow loading .vim files for different filetypes

if has('nvim')
    " Neovim Only
    set inccommand=split                " Live substitution
    let g:python_host_prog =
    \expand('$NVIM_PY2_DIR')            " Python2 binary
    let g:python3_host_prog =
    \expand('$NVIM_PY3_DIR')            " Python3 binary
else
    " Vim Only
    set pyxversion=3                    " Use Python3
    let g:python3_host_prog = '/usr/local/bin/python3.7'
endif
" }}}
" General {{{
syntax enable                   " Syntax highlighting on
colorscheme darkblue
set fileformat=unix             " Always use LF and not CRLF
set encoding=utf-8              " Default to unicode
set termencoding=utf-8          " Unicode
set synmaxcol=200               " Don't try to highlight if line > 200 chr
set laststatus=2                " Always show statusline
set showtabline=2               " Always show tabline
set visualbell                  " Visual instead of audible
set nowrap
set noshowmode                  " Hide default mode text (e.g. -- INSERT -- below statusline)
set clipboard=unnamed           " Use system clipboard
set cursorline                  " Show line under cursor's line
set ruler
set showmatch                   " Show matching pair of brackets (), [], {}
set updatetime=100              " Update more often (helps GitGutter)
set signcolumn=yes              " Always show; keep appearance consistent
set scrolloff=10                " Lines before/after cursor during scroll
set ttimeoutlen=10              " How long in ms to wait for key combinations
" }}}
" Indents {{{
set expandtab                                                   " Expand tab to spaces
set smartindent                                                 " Attempt smart indenting
set autoindent                                                  " Attempt auto indenting
set shiftwidth=4                                                " Indent width in spaces
set backspace=2                                                 " Backspace behaves as expected
let g:vim_indent_cont = &sw                                     " Indent after \ in Vim script
" }}}
" Search & replace {{{
set ignorecase                  " Ignore case while searching
set smartcase                   " Case sensitive if uppercase in pattern
set incsearch                   " Move cursor to matched string
" }}}
" Window Split {{{
set splitbelow                  " Split below instead of above
set splitright                  " Split right instead of left
" }}}
" Line numbers {{{
set number                      " Show linenumbers
set relativenumber              " Show relative numbers (hybrid with `number` enabled)

" Toggle to number mode depending on vim mode
" INSERT:       Turn off relativenumber while writing code
" NORMAL:       Turn on relativenumber for easy navigation
" NO FOCUS:     Turn off relativenumber (testing code, etc.)

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
augroup END
" }}}
" Undo {{{
" Enable persistent undo with directory
if has("persistent_undo")
    set undodir=~/.vim/undo
    set undofile
endif
" }}}
" Cursor position {{{
" Jump to last position when reopening file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
" }}}
" Shebang {{{
au BufNewFile * call SetShebang()
" }}}
" Quickfix Window {{{
" Close buffer if quickfix window is last
au BufEnter * call MyLastWindow()
function! MyLastWindow()
  " if the window is quickfix go on
  if &buftype=="quickfix"
    " if this window is last on screen quit without warning
    if winnr('$') < 2
      quit
    endif
  endif
endfunction
" }}}

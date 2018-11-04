" APPLICATION SETTINGS ==========================

set nocompatible                        " Ignore compatibility issues with Vi
set noswapfile                          " Don't create freaking swap files
set ttyfast                             " Terminal acceleration
filetype plugin on                      " Allow loading .vim files for different filetypes

if has('nvim')
    " Neovim Only
    set inccommand=split                " Live substitution
    let g:python_host_prog =
    \expand('$NVIM_PY2_DIR/bin/python') " Python2 binary
    let g:python3_host_prog =
    \expand('$NVIM_PY3_DIR/bin/python') " Python3 binary
else
    " Vim Only
    set pyxversion=3                    " Use Python3
    let g:python3_host_prog = '/usr/local/bin/python3.7'
endif

" General ---------------------------------------

syntax enable                   " Syntax highlighting on
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

" Indent behavior -------------------------------
set expandtab                   " Expand tab to spaces
set smartindent                 " Attempt smart indenting
set autoindent                  " Attempt auto indenting
set shiftwidth=2                " Indent width in spaces
set backspace=2                 " Backspace behaves as expected

" Searching & Replacing -------------------------
set ignorecase                  " Ignore case while searching
set smartcase                   " Case sensitive if uppercase in pattern
set incsearch                   " Move cursor to matched string

" Window Split ----------------------------------
set splitbelow                  " Split below instead of above
set splitright                  " Split right instead of left

" Line numbering --------------------------------
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

" Cursor position -------------------------------
" Jump to last position when reopening file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

" Add shebang if defined
au BufNewFile * call SetShebang()

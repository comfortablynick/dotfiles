" vim:fdl=1:
"  _       _ _         _
" (_)_ __ (_) |___   _(_)_ __ ___
" | | '_ \| | __\ \ / / | '_ ` _ \
" | | | | | | |_ \ V /| | | | | | |
" |_|_| |_|_|\__(_)_/ |_|_| |_| |_|
"
let g:use_init_lua = 0
" Plugin config handler {{{1
" Autocmds {{{2
augroup plugin_config_handler
    autocmd!
    autocmd! SourcePre * call s:source_handler(expand('<afile>'), 'pre')
    autocmd! SourcePost * call s:source_handler(expand('<afile>'), 'post')
augroup END

let g:plugin_config_files = map(
    \ globpath(&runtimepath, 'autoload/plugins/*.vim', 0, 1),
    \ {_, val -> fnamemodify(val, ':t:r')}
    \ )

" Debug Variables {{{2
let g:plugins_sourced = []
let g:plugins_skipped = []
let g:plugins_called = []
let g:plugins_missing_fns = []

function! s:source_handler(sourced, type) abort "{{{2
    let l:file = tolower(fnamemodify(a:sourced, ':t:r'))
    " TODO: is this really needed, or does the below match take care of it?
    " if l:full_path !~# 'pack/[^/]*/\(start\|opt\)/[^/]*/\(plugin\|autoload\)/'
    "     let g:plugins_skipped += [l:full_path]
    "     return
    " endif
    if a:type ==# 'pre'
        let g:plugins_sourced += [a:sourced]
        let g:plugins_called += [l:file]
    endif
    if index(g:plugin_config_files, l:file) > -1
        let l:fn = 'plugins#'.l:file.'#'.a:type
        if !exists('*'.l:fn)
            execute 'runtime autoload/plugins/'.l:file.'.vim'
        endif
        if exists('*'.l:fn)
            call {l:fn}()
        else
            let g:plugins_missing_fns += [l:fn]
        endif
    endif
endfunction

if has('nvim') && get(g:, 'use_init_lua') == 1
    lua require 'init'
    finish
endif

" General configuration {{{1
" Vim/Neovim Only {{{2
let g:vim_exists = executable('vim')

if has('nvim')
    " Neovim Only
    set inccommand=split                                        " Live substitution
    let g:python_host_prog = $NVIM_PY2_DIR                      " Python2 binary
    let g:python3_host_prog = $NVIM_PY3_DIR                     " Python3 binary
    let &shadafile =
        \ expand('$XDG_DATA_HOME/nvim/shada/main.shada')        " Location of nvim replacement for viminfofile
    let g:package_path = expand('$XDG_DATA_HOME/nvim/site/pack')
    let &termguicolors = !$MOSH_CONNECTION
else
    " Vim Only
    set pyxversion=3                                            " Use Python3 for pyx
    let g:python3_host_prog = '/usr/local/bin/python3.7'
    let g:package_path = expand('$HOME/.vim/pack')
endif

" Files/Swap/Backup {{{2
set noswapfile                                                  " Swap files if vim quits without saving
set autoread                                                    " Detect when a file has been changed outside of vim
set backup
set backupdir=~/.vim/backup//                                   " Store backup files

" General {{{2
filetype plugin on                                              " Allow loading .vim files for different filetypes
syntax enable                                                   " Syntax highlighting on

set encoding=utf-8                                              " Default to unicode
set shell=sh                                                    " Use posix-compatible shell
set hidden                                                      " Don't unload hidden buffers
set fileformat=unix                                             " Always use LF and not CRLF
set synmaxcol=200                                               " Don't try to highlight if line > 200 chr
set laststatus=2                                                " Always show statusline
set showtabline=2                                               " Always show tabline
set visualbell                                                  " Visual bell instead of audible
set nowrap                                                      " Text wrapping mode
set showmode                                                    " Show default mode text (e.g. -- INSERT -- below statusline)
set shortmess+=c                                                " Don't show 'Match x of x'
set clipboard=unnamed                                           " Use system clipboard
set nocursorline                                                " Show line under cursor's line (check autocmds)
set noruler                                                     " Line position (not needed if using a statusline plugin
set showmatch                                                   " Show matching pair of brackets (), [], {}
set updatetime=300                                              " Update more often (helps GitGutter)
set signcolumn=yes                                              " Always show; keep appearance consistent
set scrolloff=10                                                " Lines before/after cursor during scroll
set timeoutlen=400                                              " How long in ms to wait for key combinations (if used)
set mouse=a                                                     " Use mouse in all modes (allows mouse scrolling in tmux)
set nostartofline                                               " Don't move to start of line with j/k
set conceallevel=1                                              " Enable concealing, if defined
set concealcursor=                                              " Don't conceal when cursor goes to line
set virtualedit=onemore                                         " Allow cursor to extend past line
let g:mapleader = ','                                           " Keymap <Leader> key

" Completion {{{2
set completeopt+=preview                                        " Enable preview option for completion
set dictionary+=/usr/share/dict/words-insane                    " Dictionary file for dict completion

" Folds {{{2
set foldenable                                                  " Enable folds by default
set foldmethod=marker                                           " Fold using markers by default
set foldnestmax=5                                               " Max nested levels (default=20)

" Indents {{{2
set expandtab                                                   " Expand tab to spaces
set smartindent                                                 " Attempt smart indenting
set autoindent                                                  " Attempt auto indenting
set tabstop=4                                                   " How many spaces a tab is worth
set shiftwidth=0                                                " Columns of whitespace per indent (0 = &tabstop)
set backspace=2                                                 " Backspace behaves as expected

" Search & replace {{{2
set ignorecase                                                  " Ignore case while searching
set smartcase                                                   " Case sensitive if uppercase in pattern
set incsearch                                                   " Move cursor to matched string
set magic                                                       " Magic escaping for regex
" set gdefault                                                    " Global replacement by default

" Grep {{{2
" use ripgrep as grepprg
if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --no-ignore-vcs
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Undo {{{2
set undodir=~/.vim/undo//                                       " Undo file directory
set undofile                                                    " Enable persistent undo

" Windows/Splits {{{2
set splitright                                                  " Split right instead of left
set splitbelow                                                  " Split below instead of above
let g:window_width = &columns                                   " Initial window size (use to determine if on iPad)
" let &winblend = $VIM_SSH_COMPAT ? 0 : 10                        " Transparency of floating windows (0=opaque, 100=transparent)

" Line numbers {{{2
set number                                                      " Show linenumbers
set relativenumber                                              " Show relative numbers (hybrid with `number` enabled)

" Disable Vim default plugins {{{2
let g:loaded_gzip = 1
let g:loaded_tarPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_matchit = 1

" Disable providers {{{2
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

" Plugins {{{1
" Packadd command {{{2
function! s:packadd(arg, bang) abort
    execute 'silent! packadd '.a:arg
    if a:bang | doautoall BufRead | endif
endfunction

command! -bar -bang -complete=packadd -nargs=* Packadd
    \ call s:packadd(<q-args>, <bang>0)

" Load packages at startup {{{2
silent! packadd! vim-sandwich
silent! packadd! vim-smoothie
silent! packadd! fzf
silent! packadd! fzf.vim
silent! packadd! neoformat
silent! packadd! vim-repeat
silent! packadd! vim-fugitive
silent! packadd! vim-eunuch
silent! packadd! vim-clap
silent! packadd! vim-snippets
silent! packadd! vim-tmux-navigator
silent! packadd! vim-startify
silent! packadd! vista.vim
silent! packadd! vim-textobj-user
silent! packadd! vim-textobj-lua
silent! packadd! vim-bbye
silent! packadd! luajob
silent! packadd! nvim-lsp
silent! packadd! vim-dirvish

" Lua tools {{{2
if has('nvim')
    lua require'helpers'
endif

" Functions {{{1
" Guard() :: scriptguard utility {{{2
" Scriptguard
function! Guard(path, ...) abort
  let l:loaded_var = 'g:loaded_' . substitute(a:path, '\W', '_', 'g')
  if exists(l:loaded_var) | return 0 | endif
  for l:expr in a:000
    if !eval(l:expr)
      echoerr a:path . ' requires: ' . l:expr
      return 0
    endif
  endfor
  let {l:loaded_var} = 1
  return 1
endfunction

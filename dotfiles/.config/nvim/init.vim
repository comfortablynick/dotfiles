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

" Variables {{{2
let g:plugin_config_files = map(
    \ split(globpath(&runtimepath, 'autoload/plugins/*'), '\n'),
    \ {_, val -> fnamemodify(val, ':t:r')}
    \ )

let g:plugins_sourced = []
let g:plugins_skipped = []
let g:plugins_called = []
let g:plugins_source_errors = []

function! s:source_handler(sourced, type) abort "{{{2
    let l:file = substitute(fnamemodify(tolower(a:sourced), ':t:r'), '-', '_', 'g')
    if a:sourced =~# '^[plugin|autoload]'
        if index(g:plugins_skipped, a:sourced) < 0
            let g:plugins_skipped += [a:sourced]
        endif
        return
    endif
    if a:type ==# 'pre'
        if index(g:plugins_sourced, a:sourced) < 0
            let g:plugins_sourced += [a:sourced]
        endif
        if index(g:plugins_called, l:file) < 0
            let g:plugins_called += [l:file]
        endif
    endif
    if index(g:plugin_config_files, l:file) > -1
        let l:funcname = printf('plugins#%s#%s()', l:file, a:type)
        try
            execute 'call' l:funcname
        catch /E117:/
            if index(g:plugins_source_errors, l:file) < 0
                let g:plugins_source_errors += [v:exception]
            endif
        endtry
    endif
endfunction

function! PluginsSkipped() abort "{{{2
    let l:pl = map(g:plugins_skipped, {_, v -> {'filename': v}})
    return l:pl
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
set backupdir=/tmp/neovim_backup//                              " Store backup files

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
set ttimeoutlen=10                                              " How long in ms to wait for key combinations (if used)
set timeoutlen=200                                              " How long in ms to wait for key combinations (if used)
set mouse=a                                                     " Use mouse in all modes (allows mouse scrolling in tmux)
set nostartofline                                               " Don't move to start of line with j/k
set conceallevel=1                                              " Enable concealing, if defined
set concealcursor=                                              " Don't conceal when cursor goes to line
set virtualedit=onemore                                         " Allow cursor to extend past line
let g:mapleader = ','                                           " Keymap <Leader> key

" Completion {{{2
set completeopt+=preview                                        " Enable preview option for completion
" set dictionary+=/usr/share/dict/words-insane                    " Dictionary file for dict completion

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

" Plugins {{{1
" Load packages at startup {{{2
silent! packadd! fzf.vim
silent! packadd! neoformat
silent! packadd! vim-surround
silent! packadd! vim-repeat
silent! packadd! vim-fugitive
silent! packadd! vim-scriptease
silent! packadd! vim-commentary
silent! packadd! vim-clap
silent! packadd! vim-snippets
silent! packadd! vim-tmux-navigator
silent! packadd! vim-lion
silent! packadd! vim-startify
silent! packadd! vista.vim
silent! packadd! vim-textobj-user
silent! packadd! vim-textobj-lua
silent! packadd! nvim-luadev
silent! packadd! clever-f.vim
silent! packadd! vim-sneak
" packadd! 'lightline.vim'
" packadd! 'lightline-bufferline'

" Lua tools {{{2
if has('nvim')
    lua require'helpers'
    " lua require'lightline'
endif

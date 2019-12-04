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
let g:vim_exists = executable('vim')

" Completion filetypes {{{2
let g:completion_filetypes = {
    \ 'deoplete':
    \   [
    \       'fish',
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
    \       'typescript',
    \       'javascript',
    \       'json',
    \       'lua',
    \       'go',
    \       'python',
    \       'sh',
    \       'bash',
    \       'vim',
    \       'yaml',
    \       'snippets',
    \   ],
    \ 'mucomplete':
    \   [
    \       'pro',
    \       'mail',
    \       'txt',
    \       'ini',
    \       'muttrc',
    \   ],
    \ 'tabnine':
    \   [
    \       'markdown',
    \       'toml',
    \   ],
    \  'nvim-lsp':
    \   [],
    \ }

" Exclude from default completion
let g:nocompletion_filetypes = [
    \ 'nerdtree',
    \ ]

" Packages {{{1
call pack#init()

" General {{{2
Pack 'k-takata/minpac'
Pack 'mhinz/vim-lookup'
Pack 'scrooloose/nerdtree'
Pack 'chrisbra/Colorizer'
Pack 'mhinz/vim-startify'
Pack 'tomtom/tcomment_vim'
Pack 'tpope/vim-commentary'
Pack 'tpope/vim-surround'
Pack 'tpope/vim-projectionist'
Pack 'liuchengxu/vista.vim'
Pack 'dense-analysis/ale'
Pack 'sbdchd/neoformat'
Pack 'mbbill/undotree'
Pack 'majutsushi/tagbar'
Pack 'skywind3000/asyncrun.vim'
Pack 'vhdirk/vim-cmake'
Pack 'junegunn/fzf'
Pack 'junegunn/fzf.vim'
Pack 'airblade/vim-rooter'
Pack 'freitass/todo.txt-vim'
Pack 'justinmk/vim-sneak'
Pack 'embear/vim-localvimrc'
Pack 'liuchengxu/vim-clap'
Pack 'itchyny/lightline.vim'


" Vim Development {{{2
Pack 'tpope/vim-scriptease'
Pack 'bfredl/nvim-luadev', {'if': 'has("nvim")'}

" Themes {{{2
Pack 'NLKNguyen/papercolor-theme'
Pack 'gruvbox-community/gruvbox'

" Syntax highlighting {{{2
" Python
Pack 'numirias/semshi',
    \ {
    \   'if': 'has("nvim")',
    \   'do': ':UpdateRemotePlugins',
    \ }
Pack 'HerringtonDarkholme/yats'
Pack 'gabrielelana/vim-markdown'
Pack 'dag/vim-fish'
Pack 'cespare/vim-toml'
Pack 'bfrg/vim-cpp-modern'
Pack 'vim-jp/syntax-vim-ex'
Pack 'pearofducks/ansible-vim'
Pack 'powerman/vim-plugin-AnsiEsc'

" Git {{{2
Pack 'airblade/vim-gitgutter'
Pack 'tpope/vim-fugitive'
Pack 'junegunn/gv.vim'

" Snippets {{{2
Pack 'Shougo/neosnippet.vim'
Pack 'Shougo/neosnippet-snippets'
Pack 'SirVer/ultisnips'
Pack 'honza/vim-snippets'

" Completion {{{2
Pack 'neovim/nvim-lsp', { 'if': 'has("nvim")' }
Pack 'neoclide/coc.nvim',
    \ {
    \   'if': 'has("nvim")',
    \   'do': 'split term://yarn install --frozen-lockfile',
    \ }
Pack 'Shougo/deoplete.nvim'
Pack 'lifepillar/vim-mucomplete'
Pack 'zxqfl/tabnine-vim'
Pack 'zchee/deoplete-jedi'
Pack 'ponko2/deoplete-fish'

" Tmux {{{2
Pack 'christoomey/vim-tmux-navigator'
Pack 'christoomey/vim-tmux-runner'
" endfunction

" Local plugins {{{2
" Have to add to rtp manually
" set runtimepath+=~/git/eleline.vim

" FileType Autocmds {{{2
" Don't load if we're using coc (use coc-git instead)
autocmd vimrc FileType *
    \ if index(g:completion_filetypes['coc'], &filetype) < 0
    \ | packadd vim-gitgutter
    \ | endif

autocmd vimrc FileType *
    \ if index(g:completion_filetypes['tabnine'], &filetype) >= 0
    \ | packadd tabnine-vim
    \ | endif

autocmd vimrc FileType *
    \ if index(g:completion_filetypes['deoplete'], &filetype) >= 0
    \ | packadd deoplete.nvim
    \ | packadd deoplete-jedi
    \ | packadd deoplete-fish
    \ | endif

" Load packages {{{1
packadd! lightline.vim
packadd! fzf
packadd! fzf.vim
packadd! ale
packadd! neoformat
packadd! undotree
packadd! asyncrun.vim
packadd! vim-sneak
packadd! vim-fugitive
packadd! vim-surround
packadd! vim-localvimrc
packadd! vim-clap

" Snippets
" Load ultisnips
packadd! vim-snippets

" Syntax
packadd! vim-cpp-modern
packadd! vim-markdown
packadd! ansible-vim
packadd! semshi

" Tmux
packadd! vim-tmux-runner
packadd! vim-tmux-navigator

" vim:set fdm=marker fdl=1:

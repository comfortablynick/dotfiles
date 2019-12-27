" ====================================================
" Filename:    autoload/plugins.vim
" Description: Load vim packages and fire up package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-05
" ====================================================
command! -nargs=+ Pack call pack#add(<args>)

function! plugins#init() abort
    " General
    Pack 'chrisbra/Colorizer'
    Pack 'mhinz/vim-startify'
    Pack 'dense-analysis/ale'
    Pack 'sbdchd/neoformat'
    Pack 'skywind3000/asyncrun.vim'
    Pack 'vhdirk/vim-cmake'
    Pack 'airblade/vim-rooter'
    Pack 'embear/vim-localvimrc'
    Pack 'tpope/vim-projectionist'

    " Editing behavior
    Pack 'tpope/vim-commentary'
    Pack 'tpope/vim-surround'
    Pack 'tomtom/tcomment_vim'
    Pack 'justinmk/vim-sneak'
    Pack 'tommcdo/vim-lion'
    Pack 'aymericbeaumet/vim-symlink'

    " Explorer/finder utils
    Pack 'liuchengxu/vista.vim'
    Pack 'liuchengxu/vim-clap',
        \ {'do': ':call clap#helper#build_maple()'}
    Pack 'junegunn/fzf'
    Pack 'junegunn/fzf.vim'
    Pack 'majutsushi/tagbar'
    Pack 'mbbill/undotree'
    Pack 'scrooloose/nerdtree'
    Pack 'Shougo/defx.nvim',
        \ {'if': 'has("nvim")', 'rplugin': '1'}

    " Vim Development
    Pack 'tpope/vim-scriptease'
    Pack 'mhinz/vim-lookup'
    Pack 'bfredl/nvim-luadev', {'if': 'has("nvim")'}

    " Editor appearance
    Pack 'itchyny/lightline.vim'
    Pack 'mengelbrecht/lightline-bufferline'
    Pack 'NLKNguyen/papercolor-theme'
    Pack 'gruvbox-community/gruvbox'
    Pack 'ryanoasis/vim-devicons'

    " Syntax/filetype
    " Some must be loaded at start
    Pack 'numirias/semshi',
        \ {'if': 'has("nvim")', 'rplugin': '1'}
    Pack 'gabrielelana/vim-markdown'
    Pack 'dag/vim-fish'
    Pack 'HerringtonDarkholme/yats',    {'type': 'start'}
    Pack 'cespare/vim-toml',            {'type': 'start'}
    Pack 'bfrg/vim-cpp-modern',         {'type': 'start'}
    Pack 'vim-jp/syntax-vim-ex',        {'type': 'start'}
    Pack 'pearofducks/ansible-vim',     {'type': 'start'}
    Pack 'freitass/todo.txt-vim',       {'type': 'start'}
    Pack 'ziglang/zig.vim',             {'type': 'start'}

    " Git
    Pack 'airblade/vim-gitgutter'
    Pack 'tpope/vim-fugitive'
    Pack 'junegunn/gv.vim'

    " Snippets
    Pack 'honza/vim-snippets'

    " Completion
    Pack 'neovim/nvim-lsp', { 'if': 'has("nvim")' }
    Pack 'neoclide/coc.nvim',
        \ {
        \   'if': 'has("nvim")',
        \   'do': 'yarn install --frozen-lockfile',
        \ }

    " Tmux
    Pack 'christoomey/vim-tmux-navigator'
    Pack 'christoomey/vim-tmux-runner'
endfunction

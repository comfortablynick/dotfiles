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

    " Vim Development
    Pack 'tpope/vim-scriptease'
    Pack 'bfredl/nvim-luadev', {'if': 'has("nvim")'}

    " Themes
    Pack 'NLKNguyen/papercolor-theme'
    Pack 'gruvbox-community/gruvbox'

    " Syntax highlighting
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

    " Git
    Pack 'airblade/vim-gitgutter'
    Pack 'tpope/vim-fugitive'
    Pack 'junegunn/gv.vim'

    " Snippets
    Pack 'Shougo/neosnippet.vim'
    Pack 'Shougo/neosnippet-snippets'
    Pack 'SirVer/ultisnips'
    Pack 'honza/vim-snippets'

    " Completion
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

    " Tmux
    Pack 'christoomey/vim-tmux-navigator'
    Pack 'christoomey/vim-tmux-runner'
endfunction

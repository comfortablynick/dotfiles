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
    Pack 'tomtom/tcomment_vim'
    Pack 'tpope/vim-commentary'
    Pack 'tpope/vim-surround'
    Pack 'tpope/vim-projectionist'
    Pack 'tpope/vim-tbone'
    Pack 'dense-analysis/ale'
    Pack 'sbdchd/neoformat'
    Pack 'skywind3000/asyncrun.vim'
    Pack 'vhdirk/vim-cmake'
    Pack 'airblade/vim-rooter'
    Pack 'justinmk/vim-sneak'
    Pack 'embear/vim-localvimrc'

    " Explorer/finder utils
    Pack 'liuchengxu/vista.vim'
    Pack 'liuchengxu/vim-clap'
    Pack 'junegunn/fzf'
    Pack 'junegunn/fzf.vim'
    Pack 'majutsushi/tagbar'
    Pack 'mbbill/undotree'
    Pack 'scrooloose/nerdtree'
    Pack 'Shougo/defx.nvim',
        \ {'if': 'has("nvim")', 'do': ':UpdateRemotePlugins'}

    " Vim Development
    Pack 'tpope/vim-scriptease'
    Pack 'mhinz/vim-lookup'
    Pack 'bfredl/nvim-luadev', {'if': 'has("nvim")'}

    " Editor appearance
    Pack 'itchyny/lightline.vim'
    Pack 'NLKNguyen/papercolor-theme'
    Pack 'gruvbox-community/gruvbox'

    " Syntax/filetype
    " Python
    Pack 'numirias/semshi',
        \ {'if': 'has("nvim")', 'do': ':UpdateRemotePlugins'}
    Pack 'HerringtonDarkholme/yats'
    Pack 'gabrielelana/vim-markdown'
    Pack 'dag/vim-fish'
    Pack 'cespare/vim-toml'
    Pack 'bfrg/vim-cpp-modern'
    Pack 'vim-jp/syntax-vim-ex'
    Pack 'pearofducks/ansible-vim'
    Pack 'freitass/todo.txt-vim'

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
        \   'do': 'split term://yarn install --frozen-lockfile',
        \ }
    Pack 'lifepillar/vim-mucomplete'

    " Tmux
    Pack 'christoomey/vim-tmux-navigator'
    Pack 'christoomey/vim-tmux-runner'
endfunction

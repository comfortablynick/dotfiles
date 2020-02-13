" ====================================================
" Filename:    autoload/plugins.vim
" Description: Load vim packages and fire up package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-13 17:22:40 CST
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
    Pack 'tpope/vim-projectionist'
    Pack 'tpope/vim-repeat'

    " Editing behavior
    Pack 'tpope/vim-commentary'
    Pack 'tpope/vim-surround'
    Pack 'tomtom/tcomment_vim'
    Pack 'justinmk/vim-sneak'
    Pack 'rhysd/clever-f.vim'
    Pack 'tommcdo/vim-lion'
    Pack 'wellle/targets.vim'

    " Text objects
    Pack 'kana/vim-textobj-user'
    Pack 'spacewander/vim-textobj-lua'

    " Explorer/finder utils
    Pack 'liuchengxu/vista.vim'
    Pack 'liuchengxu/vim-clap',         {'do': ':Clap install-binary!'}
    Pack 'junegunn/fzf.vim'
    Pack 'majutsushi/tagbar'
    Pack 'mbbill/undotree'
    Pack 'preservim/nerdtree'
    Pack 'Shougo/defx.nvim',            {'if': 'has("nvim")'}

    " Vim Development
    Pack 'tpope/vim-scriptease'
    Pack 'mhinz/vim-lookup'
    Pack 'bfredl/nvim-luadev',          {'if': 'has("nvim")'}
    Pack 'tweekmonster/startuptime.vim',

    " Editor appearance
    Pack 'itchyny/lightline.vim'
    Pack 'mengelbrecht/lightline-bufferline'
    Pack 'NLKNguyen/papercolor-theme'
    Pack 'gruvbox-community/gruvbox'
    Pack 'ryanoasis/vim-devicons'

    " Syntax/filetype
    " Some must be loaded at start
    Pack 'numirias/semshi',             {'if': 'has("nvim")'}
    Pack 'dag/vim-fish',                {'type': 'start'}
    Pack 'HerringtonDarkholme/yats',    {'type': 'start'}
    Pack 'cespare/vim-toml',            {'type': 'start'}
    Pack 'bfrg/vim-cpp-modern',         {'type': 'start'}
    Pack 'vim-jp/syntax-vim-ex',        {'type': 'start'}
    Pack 'pearofducks/ansible-vim',     {'type': 'start'}
    Pack 'freitass/todo.txt-vim',       {'type': 'start'}
    Pack 'ziglang/zig.vim',             {'type': 'start'}
    Pack 'tbastos/vim-lua',             {'type': 'start'}
    Pack 'SidOfc/mkdx',                 {'type': 'start'}
    Pack 'habamax/vim-asciidoctor',     {'type': 'start'}
    Pack 'masukomi/vim-markdown-folding',
        \ {'type': 'start'}

    " Git
    Pack 'airblade/vim-gitgutter'
    Pack 'tpope/vim-fugitive'
    Pack 'junegunn/gv.vim'

    " Snippets
    Pack 'honza/vim-snippets'

    " Completion
    Pack 'neovim/nvim-lsp',             {'if': 'has("nvim")'}
    Pack 'neoclide/coc.nvim',
        \ {
        \   'if': 'has("nvim")',
        \   'do': {-> 'yarn install --frozen-lockfile'},
        \ }

    " Tmux
    Pack 'christoomey/vim-tmux-navigator'
    Pack 'comfortablynick/vim-tmux-runner'
endfunction

" ====================================================
" Filename:    autoload/plugins.vim
" Description: Load vim packages and fire up package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-03-19 11:39:29 CDT
" ====================================================
command! -nargs=+ Pack call pack#add(<args>)

function! plugins#init() abort
    " General
    Pack 'chrisbra/Colorizer'
    Pack 'mhinz/vim-startify'
    Pack 'vhdirk/vim-cmake'
    Pack 'airblade/vim-rooter'
    Pack 'tpope/vim-repeat'
    Pack 'tpope/vim-eunuch'
    Pack 'moll/vim-bbye'
    Pack 'psliwka/vim-smoothie'

    " Linters/formatters/runners
    Pack 'dense-analysis/ale'
    Pack 'sbdchd/neoformat'
    Pack 'skywind3000/asyncrun.vim'
    Pack 'skywind3000/asynctasks.vim'
    Pack 'tpope/vim-dispatch'

    " Editing behavior
    Pack 'tpope/vim-commentary'
    Pack 'tpope/vim-surround'
    Pack 'tpope/vim-unimpaired'
    Pack 'machakann/vim-sandwich'
    Pack 'tomtom/tcomment_vim'
    Pack 'justinmk/vim-sneak'
    Pack 'easymotion/vim-easymotion'
    Pack 'rhysd/clever-f.vim'
    Pack 'tommcdo/vim-lion'
    Pack 'wellle/targets.vim'

    " Text objects
    Pack 'kana/vim-textobj-user'
    Pack 'spacewander/vim-textobj-lua'

    " Explorer/finder utils
    Pack 'kevinhwang91/rnvimr',         {'do': 'make sync'}
    Pack 'liuchengxu/vista.vim'
    Pack 'liuchengxu/vim-clap',         {'do': ':Clap install-binary!'}
    Pack 'junegunn/fzf',                {'do': ':packadd fzf \| :call fzf#install'}
    Pack 'junegunn/fzf.vim'
    Pack 'majutsushi/tagbar'
    Pack 'mbbill/undotree'
    Pack 'preservim/nerdtree'
    Pack 'Shougo/defx.nvim',            {'if': 'has("nvim")'}
    Pack 'tpope/vim-projectionist'
    Pack 'kyazdani42/nvim-tree.lua'
    Pack 'justinmk/vim-dirvish'
    Pack 'haorenW1025/floatLf-nvim'

    " Vim Development
    Pack 'tpope/vim-scriptease'
    Pack 'mhinz/vim-lookup'
    Pack 'bfredl/nvim-luadev',          {'if': 'has("nvim")'}
    Pack 'tweekmonster/startuptime.vim',
    Pack 'TravonteD/luajob'

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
    Pack 'vim-jp/syntax-vim-ex'
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
    Pack 'SirVer/ultisnips'
    Pack 'honza/vim-snippets'

    " Completion
    Pack 'neovim/nvim-lsp',             {'if': 'has("nvim")'}
    Pack 'neoclide/coc.nvim',
        \ {
        \   'if': 'has("nvim")',
        \   'do': 'yarn install --frozen-lockfile',
        \ }
    Pack 'lifepillar/vim-mucomplete'

    " Tmux
    Pack 'christoomey/vim-tmux-navigator'
    Pack 'comfortablynick/vim-tmux-runner'
endfunction

" Packadd if needed and call supplied function
function! plugins#lazy_call(package, funcname, ...) abort
    if !exists('*'.a:funcname)
        execute 'packadd' a:package
    endif
    return call(a:funcname, a:000)
endfunction

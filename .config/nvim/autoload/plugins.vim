" ====================================================
" Filename:    autoload/plugins.vim
" Description: Load vim plugins and package manager
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_autoload_plugins' | if exists(s:guard) | finish | endif
let {s:guard} = 1

let g:package_path = get(g:, 'package_path', expand('$XDG_DATA_HOME/nvim/site'))

function! plugins#init() abort
    " vim-packager init
    let l:packager_path = g:package_path.'/pack/packager/opt/vim-packager'
    if !isdirectory(l:packager_path)
        echo 'Downloading vim-packager'
        call system('git clone https://github.com/kristijanhusak/vim-packager '.l:packager_path)
    endif
    packadd vim-packager
    command! -nargs=+ Pack call packager#add(<args>)
    call packager#init({
        \ 'dir': g:package_path.'/pack/packager',
        \ 'default_plugin_type': 'opt',
        \ 'jobs': 0,
        \ })
    Pack 'kristijanhusak/vim-packager'

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
    Pack 'psf/black', {'branch': 'stable'}
    Pack 'skywind3000/asyncrun.vim'
    Pack 'skywind3000/asynctasks.vim', {'do': 'ln -sf $(pwd)/bin/asynctask ~/.local/bin'}
    Pack 'kkoomen/vim-doge'

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
    Pack 'bfredl/nvim-miniyank'

    " Explorer/finder utils
    Pack 'kevinhwang91/rnvimr',         {'do': 'pip3 install -U pynvim'}
    Pack 'liuchengxu/vista.vim'
    Pack 'liuchengxu/vim-clap',         {'do': ':Clap install-binary!'}
    Pack 'junegunn/fzf',                {'do': { p -> s:fzf_post(p) }}
    Pack 'junegunn/fzf.vim'
    Pack 'laher/fuzzymenu.vim'
    Pack 'majutsushi/tagbar'
    Pack 'mbbill/undotree'
    Pack 'preservim/nerdtree'
    Pack 'Shougo/defx.nvim'
    Pack 'tpope/vim-projectionist'
    Pack 'kyazdani42/nvim-tree.lua'
    Pack 'justinmk/vim-dirvish'
    Pack 'srstevenson/vim-picker'
    Pack 'voldikss/vim-floaterm'

    " Vim Development
    Pack 'tpope/vim-scriptease'
    Pack 'mhinz/vim-lookup'
    Pack 'bfredl/nvim-luadev'
    Pack 'tweekmonster/startuptime.vim'
    Pack 'TravonteD/luajob'

    " Editor appearance
    Pack 'itchyny/lightline.vim'
    Pack 'mengelbrecht/lightline-bufferline'
    Pack 'NLKNguyen/papercolor-theme'
    Pack 'gruvbox-community/gruvbox'
    Pack 'ryanoasis/vim-devicons'

    " Syntax/filetype
    " Some must be loaded at start
    Pack 'sheerun/vim-polyglot',        {'type': 'start'}
    Pack 'freitass/todo.txt-vim',       {'type': 'start'}
    Pack 'SidOfc/mkdx',                 {'type': 'start'}
    Pack 'habamax/vim-asciidoctor',     {'type': 'start'}
    Pack 'kevinoid/vim-jsonc',          {'type': 'start'}
    Pack 'masukomi/vim-markdown-folding',
        \ {'type': 'start'}

    " Git
    Pack 'airblade/vim-gitgutter'
    Pack 'tpope/vim-fugitive'
    Pack 'junegunn/gv.vim'
    Pack 'iberianpig/tig-explorer.vim'

    " Snippets
    Pack 'SirVer/ultisnips'
    Pack 'honza/vim-snippets'

    " Completion
    Pack 'neovim/nvim-lsp'
    Pack 'nvim-lua/completion-nvim'
    Pack 'neoclide/coc.nvim',           {'do': {-> coc#util#install()}}
    Pack 'lifepillar/vim-mucomplete'

    " Tmux
    Pack 'christoomey/vim-tmux-navigator'
    Pack 'RyanMillerC/better-vim-tmux-resizer'
    Pack 'comfortablynick/vim-tmux-runner'
endfunction

" Fzf update hook
function! s:fzf_post(plugin) abort
    execute 'AsyncRun cd' a:plugin['dir']
        \ '&& ./install --bin'
        \ '&& ln -sf $(pwd)/bin/* ~/.local/bin'
        \ '&& ln -sf $(pwd)/man/man1/* ~/.local/share/man/man1'
endfunction

" packadd and call supplied function
function! plugins#lazy_call(package, funcname, ...) abort
    execute 'packadd' a:package
    return call(a:funcname, a:000)
endfunction

" packadd and execute command + args
function! plugins#lazy_exe(package, cmd, ...) abort
    if !plugins#exists(a:package)
        echohl WarningMsg
        echo 'Package' a:package 'does not exist!'
        echohl None
        return
    endif
    execute 'packadd' a:package '|' a:cmd join(a:000)
endfunction

" check if plugin in &packpath (`plugin` can be a glob pattern)
function! plugins#exists(plugin) abort
    return !empty(globpath(&packpath, 'pack/*/*/'.a:plugin))
endfunction

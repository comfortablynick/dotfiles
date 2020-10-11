" ====================================================
" Filename:    autoload/plugins.vim
" Description: Load vim plugins and package manager
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_autoload_plugins' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Plugin definitions {{{1
" Vim-Packager init {{{2
let g:package_path = get(g:, 'package_path', expand('$XDG_DATA_HOME/nvim/site'))

function! plugins#init() abort
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

    " General {{{2
    Pack 'chrisbra/Colorizer'
    Pack 'airblade/vim-rooter'
    Pack 'tpope/vim-repeat'
    Pack 'tpope/vim-eunuch'
    Pack 'moll/vim-bbye'
    Pack 'psliwka/vim-smoothie'

    " Linters/formatters/runners {{{2
    Pack 'dense-analysis/ale'
    Pack 'sbdchd/neoformat'
    Pack 'psf/black',                  {'branch': 'stable'}
    Pack 'skywind3000/asyncrun.vim'
    Pack 'skywind3000/asynctasks.vim', {'do': 'ln -sf $(pwd)/bin/asynctask ~/.local/bin'}
    Pack 'kkoomen/vim-doge'

    " Editing behavior {{{2
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
    Pack 'antoinemadec/FixCursorHold.nvim'

    " Explorer/finder utils {{{2
    Pack 'kevinhwang91/rnvimr', {'do': 'pip3 install -U pynvim'}
    Pack 'liuchengxu/vista.vim'
    Pack 'liuchengxu/vim-clap', {'do': ':Clap install-binary!'}
    Pack 'junegunn/fzf',        {'do': { p -> s:fzf_post(p) }}
    Pack 'junegunn/fzf.vim'
    Pack 'laher/fuzzymenu.vim'
    Pack 'majutsushi/tagbar'
    Pack 'mbbill/undotree'
    Pack 'preservim/nerdtree'
    Pack 'Shougo/defx.nvim'
    Pack 'kyazdani42/nvim-tree.lua'
    Pack 'justinmk/vim-dirvish'
    Pack 'srstevenson/vim-picker'
    Pack 'voldikss/vim-floaterm'

    " Vim Development {{{2
    Pack 'tpope/vim-scriptease'
    Pack 'mhinz/vim-lookup'
    Pack 'bfredl/nvim-luadev'
    Pack 'tweekmonster/startuptime.vim'
    Pack 'dstein64/vim-startuptime'
    Pack 'TravonteD/luajob'

    " Editor appearance {{{2
    Pack 'itchyny/lightline.vim'
    Pack 'mengelbrecht/lightline-bufferline'
    Pack 'NLKNguyen/papercolor-theme'
    Pack 'gruvbox-community/gruvbox'
    Pack 'ryanoasis/vim-devicons'

    " Syntax/filetype {{{2
    Pack 'vhdirk/vim-cmake'
    Pack 'cespare/vim-toml',              {'type': 'start'}
    Pack 'tbastos/vim-lua',               {'type': 'start'}
    Pack 'blankname/vim-fish',            {'type': 'start'}
    Pack 'vim-jp/syntax-vim-ex',          {'type': 'start'}
    Pack 'freitass/todo.txt-vim',         {'type': 'start'}
    Pack 'SidOfc/mkdx',                   {'type': 'start'}
    Pack 'habamax/vim-asciidoctor',       {'type': 'start'}
    Pack 'masukomi/vim-markdown-folding', {'type': 'start'}

    " Git {{{2
    Pack 'airblade/vim-gitgutter'
    Pack 'mhinz/vim-signify'
    Pack 'tpope/vim-fugitive'
    Pack 'junegunn/gv.vim'
    Pack 'iberianpig/tig-explorer.vim'
    Pack 'TimUntersberger/neogit'           " Experimental

    " Snippets {{{2
    Pack 'SirVer/ultisnips'
    Pack 'honza/vim-snippets'
    Pack 'norcalli/snippets.nvim'

    " Language server/completion {{{2
    Pack 'neovim/nvim-lspconfig'
    Pack 'nvim-lua/lsp-status.nvim'
    Pack 'nvim-lua/completion-nvim'
    Pack 'nvim-lua/diagnostic-nvim'
    Pack 'steelsojka/completion-buffers'
    Pack 'lifepillar/vim-mucomplete'
    Pack 'neoclide/coc.nvim', {'do': {-> coc#util#install()}}

    " Training {{{2
    Pack 'tjdevries/train.nvim'

    " Tmux {{{2
    Pack 'christoomey/vim-tmux-navigator'
    Pack 'RyanMillerC/better-vim-tmux-resizer'
    Pack 'comfortablynick/vim-tmux-runner'
endfunction

" Helper functions {{{1
" fzf_post :: fzf update hook {{{2
function! s:fzf_post(plugin) abort
    execute 'AsyncRun cd' a:plugin['dir']
        \ '&& ./install --bin'
        \ '&& ln -sf $(pwd)/bin/* ~/.local/bin'
        \ '&& ln -sf $(pwd)/man/man1/* ~/.local/share/man/man1'
endfunction

" plugins#lazy_run :: Lazy-load a package on a command or funcref {{{2
" Inspired by:
" https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/autoload/util.vim
" Optional options dict:
" `start` Range start
" `end` Range end
" `bang` <bang> from command
" `args` <q-args> from command
function plugins#lazy_run(cmd, package, ...)
    if !plugins#exists(a:package)
        echohl WarningMsg
        echo 'Package' a:package 'not found in packpath!'
        echohl None
        return
    endif
    let l:packages   = a:package
    let l:args       = get(a:, 1, {})
    let l:before     = get(l:args, 'before', [])
    let l:after      = get(l:args, 'after', [])
    let l:start      = get(l:args, 'start', 0)
    let l:end        = get(l:args, 'end',   0)
    let l:bang       = get(l:args, 'bang',  '')
    let l:extra_args = get(l:args, 'args',  '')
    " Exec before command(s)
    if type(l:before) != v:t_list
        let l:before = [l:before]
    endif
    for l:before_cmd in l:before
        execute l:before_cmd
    endfor

    " Source packages
    if type(l:packages) != v:t_list
        let l:packages = [l:packages]
    endif
    for l:package in l:packages
        execute 'packadd' l:package
    endfor

    " Exec after command(s)
    if type(l:after) != v:t_list
        let l:after = [l:after]
    endif
    for l:after_cmd in l:after
        execute l:after_cmd
    endfor
    if type(a:cmd) == v:t_func
        return a:cmd()
    endif
    " Build command
    let l:final_cmd = printf(
        \ '%s%s%s %s',
        \ (l:start == l:end ? '' : (l:start . ',' . l:end)),
        \ a:cmd,
        \ l:bang,
        \ l:extra_args
        \ )
    if get(l:args, 'debug', 0)
        " Debug print
        echo l:final_cmd
        return
    endif
    execute l:final_cmd
endfunction

" plugins#exists :: check if plugin exists in &packpath {{{2
" `plugin` Plugin name or glob pattern
function plugins#exists(plugin)
    return !empty(globpath(&packpath, 'pack/*/*/'.a:plugin))
endfunction

" vim:fdl=1:

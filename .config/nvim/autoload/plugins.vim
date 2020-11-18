" Plugin definitions {{{1
let g:package_path = get(g:, 'package_path', expand('$XDG_DATA_HOME/nvim/site'))
let g:pack_pre_called = []
let g:pack_post_called = []
let g:pack_called = []
let g:pack_sourced = []
let g:vim_sourced = []

command -nargs=+ Plug call packager#add(<args>)
command -nargs=+ PlugLocal call packager#local(<args>)

" function plugins#init() :: load packages with vim-packager {{{2
function plugins#init()
    let l:packager_path = g:package_path.'/pack/packager/opt/vim-packager'
    if !isdirectory(l:packager_path)
        echo 'Downloading vim-packager'
        call system('git clone https://github.com/kristijanhusak/vim-packager '..l:packager_path)
    endif
    packadd vim-packager
    " Emulate vim-plug command for ease of copy/pasting plugins
    call packager#init(#{
        \ dir: g:package_path.'/pack/packager',
        \ default_plugin_type: 'opt',
        \ jobs: 0,
        \ })
    Plug 'kristijanhusak/vim-packager'

    " General {{{2
    " Plug 'chrisbra/Colorizer'
    Plug 'airblade/vim-rooter'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-eunuch'
    Plug 'moll/vim-bbye'
    Plug 'psliwka/vim-smoothie'

    " Linters/formatters/runners {{{2
    Plug 'dense-analysis/ale'
    Plug 'sbdchd/neoformat'
    Plug 'psf/black',                  {'branch': 'stable'}
    Plug 'skywind3000/asyncrun.vim'
    Plug 'skywind3000/asynctasks.vim', {'do': 'ln -sf $(pwd)/bin/asynctask ~/.local/bin'}
    Plug 'kkoomen/vim-doge'

    " Editing behavior {{{2
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
    Plug 'machakann/vim-sandwich'
    Plug 'tomtom/tcomment_vim'
    Plug 'justinmk/vim-sneak'
    Plug 'easymotion/vim-easymotion'
    Plug 'rhysd/clever-f.vim'
    Plug 'tommcdo/vim-lion'
    Plug 'wellle/targets.vim'
    Plug 'tommcdo/vim-exchange'
    Plug 'bfredl/nvim-miniyank'
    Plug 'antoinemadec/FixCursorHold.nvim'

    " Explorer/finder utils {{{2
    let s:fzf_hook = './install --bin && ln -sf $(pwd)/bin/* ~/.local/bin && ln -sf $(pwd)/man/man1/* ~/.local/share/man/man1'
    Plug 'junegunn/fzf',             {'do': s:fzf_hook}
    Plug 'kevinhwang91/rnvimr',      {'do': 'pip3 install -U pynvim'}
    Plug 'liuchengxu/vista.vim'
    Plug 'liuchengxu/vim-clap',      {'do': ':Clap install-binary!'}
    Plug 'junegunn/fzf.vim'
    Plug 'laher/fuzzymenu.vim'
    Plug 'majutsushi/tagbar'
    Plug 'mbbill/undotree'
    Plug 'preservim/nerdtree'
    Plug 'Shougo/defx.nvim'
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'justinmk/vim-dirvish'
    Plug 'srstevenson/vim-picker'
    Plug 'voldikss/vim-floaterm'
    " TODO: is this any better than using Lf in floaterm?
    Plug 'haorenW1025/floatLf-nvim', {'do': 'pip3 install -U neovim-remote'}

    " Vim Development {{{2
    Plug 'tpope/vim-scriptease'
    Plug 'mhinz/vim-lookup'
    Plug 'tweekmonster/startuptime.vim'
    Plug 'dstein64/vim-startuptime'

    " Editor appearance {{{2
    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'
    Plug 'ryanoasis/vim-devicons'
    Plug 'kyazdani42/nvim-web-devicons'

    " Colorschemes {{{2
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'lifepillar/vim-gruvbox8'

    " Syntax/filetype {{{2
    Plug 'vhdirk/vim-cmake'
    Plug 'cespare/vim-toml'
    Plug 'tbastos/vim-lua'
    Plug 'vim-jp/syntax-vim-ex',          {'type': 'start'}
    Plug 'blankname/vim-fish',            {'type': 'start'}
    Plug 'dbeniamine/todo.txt-vim',       {'type': 'start'}
    Plug 'habamax/vim-asciidoctor',       {'type': 'start'}
    Plug 'masukomi/vim-markdown-folding', {'type': 'start'}

    " Git {{{2
    Plug 'airblade/vim-gitgutter'
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/gv.vim'
    Plug 'iberianpig/tig-explorer.vim'
    Plug 'TimUntersberger/neogit'

    " Snippets {{{2
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'norcalli/snippets.nvim'

    " Language server/completion {{{2
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/lsp-status.nvim'
    Plug 'nvim-lua/completion-nvim'
    Plug 'steelsojka/completion-buffers'
    Plug 'lifepillar/vim-mucomplete'
    Plug 'neoclide/coc.nvim', {'do': {-> coc#util#install()}}

    " Lua/nvim {{{2
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'bfredl/nvim-luadev'
    Plug 'TravonteD/luajob'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'romgrk/barbar.nvim'
    Plug 'norcalli/nvim-base16.lua'
    " Plug 'tjdevries/colorbuddy.vim'
    " Plug 'Th3Whit3Wolf/spacebuddy'

    " Training/Vim help {{{2
    Plug 'tjdevries/train.nvim'
    Plug 'liuchengxu/vim-which-key'

    " Tmux {{{2
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'RyanMillerC/better-vim-tmux-resizer'
    Plug 'comfortablynick/vim-tmux-runner'
endfunction

" Functions {{{1
" function plugins#lazy_run() :: Lazy-load a package on a command or funcref {{{2
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
    let l:packages   = type(a:package) !=# v:t_list ? [a:package] : a:package
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
    for l:package in l:packages
        execute 'packadd' l:package
    endfor

    " Exec after command(s)
    if type(l:after) !=# v:t_list
        let l:after = [l:after]
    endif
    for l:after_cmd in l:after
        execute l:after_cmd
    endfor
    if type(a:cmd) ==# v:t_func
        return a:cmd()
    endif
    if type(l:bang) ==# v:t_number
        let l:bang = l:bang ==# 1 ? '!' : ''
    endif

    if type(l:extra_args) ==# v:t_list
        let l:extra_args = join(l:extra_args, ' ')
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

" function plugins#exists() :: check if plugin exists in &packpath {{{2
" `plugin` Plugin name or glob pattern
function plugins#exists(plugin)
    return !empty(globpath(&packpath, 'pack/*/*/'.a:plugin))
endfunction

" function s:get_pack_name() :: Get pack name from file within pack {{{2
function s:get_pack_name(filename)
    return matchstr(a:filename, '[\/]pack[\/][^\/]\+[\/]\%(opt\|start\)[\/]\zs[^\/]\+')
endfunction

function s:source_handler(sourced, pre) "{{{2
    let l:type = a:pre == 1 ? 'pre' : 'post'
    let l:file = get(plugins#packs_installed(), a:sourced, '')
    " Return if we don't have file in autoload/plugins/{l:file}.vim
    " or if function has been called previously
    if index(s:config_files(), l:file) < 0
        \ || index(g:pack_{l:type}_called, l:file) > -1
        return
    endif
    let g:pack_{l:type}_called += [l:file]
    if l:type ==# 'pre'
        let g:pack_sourced += [a:sourced]
        let g:pack_called += [l:file]
    endif
    try
        call plugins#{l:file}#{l:type}()
    catch /^Vim\%((\a\+)\)\=:E117/
        " fn doesn't exist; do nothing
    endtry
endfunction

" function s:config_pack() :: Load configuration for pack filename " {{{2
function s:config_pack(filename, pre)
    let l:packname = s:get_pack_name(a:filename)
    call s:source_handler(l:packname, a:pre)
endf

" function plugins#packs_installed() :: Get all pack names in rtp " {{{2
" NOTE: does not capture ftplugin-only plugins (not sure if this matters)
function plugins#packs_installed()
    if !exists('s:packs_installed')
        let s:packs_installed = {}
        let l:packs = globpath(&packpath, 'pack/*/*/*/plugin/*.vim', 0, 1)
        for l:pack in l:packs
            let l:packname = s:get_pack_name(l:pack)
            let s:packs_installed[l:packname] = fnamemodify(l:pack, ':t:r')
        endfor
    endif
    return s:packs_installed
endfunction

" function s:config_files() :: Get files in au/plugins/.vim {{{2
function s:config_files()
    if !exists('s:pack_config_files')
        let s:pack_config_files = map(
            \ globpath(&runtimepath, 'autoload/plugins/*.vim', 0, 1),
            \ {_, val -> fnamemodify(val, ':t:r')}
            \ )
    endif
    return s:pack_config_files
endfunction

" function plugins#packadd() :: Load plugin and handle config manually {{{2
function plugins#packadd(...)
    let l:save_ei = &eventignore
    set eventignore+=SourcePre,SourcePost
    for l:pack in a:000
        call s:source_handler(l:pack, 1)
        execute 'silent! packadd' l:pack
        call s:source_handler(l:pack, 0)
    endfor
    let &eventignore = l:save_ei
endfunction

" function plugins#set_source_handler() :: set config handlers for packages {{{2
function plugins#set_source_handler()
    command -nargs=+ -complete=packadd Packload call plugins#packadd(<q-args>)
    augroup autoload_plugins
        autocmd!
        autocmd SourcePre  */pack/* call s:config_pack(expand('<amatch>'), 1)
        autocmd SourcePost */pack/* call s:config_pack(expand('<amatch>'), 0)
    augroup END
endfunction
" vim:fdl=1:

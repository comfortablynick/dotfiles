" Plugin definitions {{{1
let g:package_path = get(g:, 'package_path', expand('$XDG_DATA_HOME/nvim/site'))
let g:packages = {}

command -nargs=+ Plug call packager#add(<args>)

" function plugins#init() :: load packages with vim-packager {{{2
function plugins#init() abort
    " Determine OS if any plugins are os-specific
    if !exists('g:os')
        if has('win64') || has('win32')
            let g:os = 'Windows'
        else
            let g:os = substitute(system('uname'), '\n', '', '')
        endif
    endif

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
    Plug 'airblade/vim-rooter'
    Plug 'tpope/vim-eunuch'
    Plug 'moll/vim-bbye'
    Plug 'psliwka/vim-smoothie'

    " Linters/formatters/runners {{{2
    Plug 'kkoomen/vim-doge',           {'do': {-> doge#install(#{headless: 1})}}
    Plug 'dense-analysis/ale'
    Plug 'sbdchd/neoformat'
    " Plug 'psf/black'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'skywind3000/asynctasks.vim', {'do': 'ln -sf $(pwd)/bin/asynctask ~/.local/bin'}
    Plug 'michaelb/sniprun',           {'do': './install.sh'}
    Plug 'tpope/vim-dispatch'

    " Editing behavior {{{2
    Plug 'bfredl/nvim-miniyank'
    Plug 'junegunn/vim-easy-align'
    Plug 'tpope/vim-projectionist'

    " Motions {{{2
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-unimpaired'
    " Lua impl of easymotion
    Plug 'phaazon/hop.nvim'

    " [s|S]{char}{char} motion
    Plug 'justinmk/vim-sneak'
    " [f|F]{char} motion
    Plug 'rhysd/clever-f.vim'

    " Text objects {{{2
    Plug 'wellle/targets.vim'
    Plug 'tommcdo/vim-exchange'
    Plug 'machakann/vim-sandwich'

    " Commenting
    Plug 'tpope/vim-commentary'
    Plug 'tomtom/tcomment_vim'

    " Explorer/finder utils {{{2
    Plug 'junegunn/fzf',
        \ {'do': './install --bin && ln -sf $(pwd)/bin/* ~/.local/bin && ln -sf $(pwd)/man/man1/* ~/.local/share/man/man1'}
    Plug 'kevinhwang91/rnvimr',      {'do': 'pip3 install -U pynvim'}
    Plug 'liuchengxu/vista.vim'
    Plug 'liuchengxu/vim-clap',      {'do': ':Clap install-binary!'}
    Plug 'junegunn/fzf.vim'
    Plug 'laher/fuzzymenu.vim'
    Plug 'mbbill/undotree'
    Plug 'preservim/nerdtree'
    Plug 'justinmk/vim-dirvish'
    Plug 'srstevenson/vim-picker'
    Plug 'voldikss/vim-floaterm'

    " Vim Development {{{2
    Plug 'tpope/vim-scriptease'
    Plug 'mhinz/vim-lookup'
    Plug 'tweekmonster/startuptime.vim'
    Plug 'dstein64/vim-startuptime'

    " Editor appearance {{{2
    Plug 'ryanoasis/vim-devicons'
    Plug 'kyazdani42/nvim-web-devicons'

    " Colorschemes {{{2
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'lifepillar/vim-gruvbox8'

    " Syntax/filetype {{{2
    Plug 'vhdirk/vim-cmake'
    Plug 'cespare/vim-toml'
    Plug 'tbastos/vim-lua'
    Plug 'Glench/Vim-Jinja2-Syntax',          {'type': 'start'}
    Plug 'blankname/vim-fish',                {'type': 'start'}
    Plug 'habamax/vim-asciidoctor',           {'type': 'start'}
    Plug 'benknoble/gitignore-vim',           {'type': 'start'}
    call packager#local('~/git/todo.txt-vim', {'type': 'start'})

    " Git {{{2
    Plug 'airblade/vim-gitgutter'
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/gv.vim'
    Plug 'iberianpig/tig-explorer.vim'
    Plug 'TimUntersberger/neogit', {'requires': ['nvim-lua/plenary.nvim']}

    " Snippets {{{2
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'norcalli/snippets.nvim'
    Plug 'L3MON4D3/LuaSnip'

    " Language server/completion {{{2
    Plug 'neovim/nvim-lspconfig', {'requires': [
        \ 'nvim-lua/lsp-status.nvim',
        \ 'nvim-lua/lsp_extensions.nvim',
        \ 'glepnir/lspsaga.nvim',
        \ ]}
    Plug 'nvim-lua/completion-nvim', {'requires': ['steelsojka/completion-buffers']}
    Plug 'hrsh7th/nvim-compe'
    Plug 'lifepillar/vim-mucomplete'

    " Lua/nvim {{{2
    Plug 'rktjmp/lush.nvim'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'bfredl/nvim-luadev'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'romgrk/barbar.nvim'
    Plug 'norcalli/profiler.nvim'
    Plug 'romgrk/todoist.nvim',             {'do': ':TodoistInstall'}
    Plug 'kevinhwang91/nvim-bqf'
    Plug 'antoinemadec/FixCursorHold.nvim'

    " Training/Vim help {{{2
    Plug 'tjdevries/train.nvim'
    Plug 'liuchengxu/vim-which-key'

    " Tmux {{{2
    Plug 'christoomey/vim-tmux-navigator'
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
    let l:type = a:pre ? 'pre' : 'post'
    let l:file = get(plugins#packs_installed(), a:sourced, '')
    let g:packages[a:sourced] = get(
        \ g:packages,
        \ a:sourced,
        \ #{plugin_file: l:file, sourced_pre: 0, sourced_post: 0}
        \ )
    " Case-insensitive match of filename
    let l:config_files_idx = index(s:config_files(), l:file, 0, v:true)
    " Return if we don't have file in autoload/plugins/{l:file}.vim or if already sourced
    if l:config_files_idx == -1
            \ || g:packages[a:sourced]['sourced_'..l:type]
        return
    endif
    " Replace with actual filename that we matched
    let l:file = s:config_files()[l:config_files_idx]
    if l:type ==# 'pre'
        let g:packages[a:sourced]['sourced_pre'] = 1
        exe 'silent! doautocmd User plugin#'..l:file
    else
        let g:packages[a:sourced]['sourced_post'] = 1
    endif
    try
        return plugins#{l:file}#{l:type}()
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
    if !exists('g:pack_config_files')
        let g:pack_config_files = map(
            \ globpath(&runtimepath, 'autoload/plugins/*.vim', 0, 1),
            \ {_, val -> fnamemodify(val, ':t:r')}
            \ )
    endif
    return g:pack_config_files
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
    command! -nargs=+ -complete=packadd Packload call plugins#packadd(<q-args>)
    augroup autoload_plugins
        autocmd!
        autocmd SourcePre  */pack/* call s:config_pack(expand('<amatch>'), v:true)
        autocmd SourcePost */pack/* call s:config_pack(expand('<amatch>'), v:false)
    augroup END
endfunction
" vim:fdl=1:

let g:package_manager = 'vim-packager'

let g:package_defer_time = 300

" Package management
if get(g:, 'use_packer', 0)
    command! PackerInstall packadd packer.nvim | lua require('plugins').install()
    command! PackerUpdate  packadd packer.nvim | lua require('plugins').update()
    command! PackerSync    packadd packer.nvim | lua require('plugins').sync()
    command! PackerClean   packadd packer.nvim | lua require('plugins').clean()
    command! PackerCompile packadd packer.nvim | lua require('plugins').compile()
else
    command!       PackInstall call plugins#init() | call packager#install()
    command! -bang PackUpdate  call plugins#init() | call packager#update({'force_hooks': '<bang>'})
    command!       PackClean   call plugins#init() | call packager#clean()
    command!       PackStatus  call plugins#init() | call packager#status()
endif

augroup plugin_pack
    autocmd!
    autocmd VimEnter * ++once call timer_start(g:package_defer_time, { -> s:deferred_load() })
augroup END

" Load packages that are safe to defer
function! s:deferred_load()
    packadd fzf
    packadd fzf.vim
    packadd targets.vim
    packadd vim-exchange
    " packadd vim-commentary
    packadd tcomment_vim
    packadd vim-unimpaired
    packadd clever-f.vim
    packadd vim-sneak
    packadd vim-tmux-navigator
    packadd better-vim-tmux-resizer
    " packadd tig-explorer.vim
    packadd vim-sandwich
    packadd vim-smoothie
    packadd vim-repeat
    packadd vim-eunuch
    packadd vim-clap
    packadd vim-snippets
    packadd vista.vim
    packadd vim-bbye
    packadd vim-floaterm
    packadd vim-picker
    packadd vim-devicons
    packadd vim-lion

    if has('nvim')
        " Seems to have issue on vim
        packadd nvim-miniyank
        packadd plenary.nvim
    endif

    packadd vim-fugitive
    call FugitiveDetect(expand('%:p'))

    " Load local vimrc if env var
    call localrc#load_from_env()
endfunction

finish

" Plugins {{{1
" Packager setup {{{2
let g:packager_path = expand("$XDG_DATA_HOME/nvim/site")..'/pack/packager-test'
let s:vim_packager_path = g:packager_path..'/opt/vim-packager'
if !isdirectory(s:vim_packager_path)
    echo 'Downloading vim-packager'
    call system('git clone https://github.com/kristijanhusak/vim-packager '..s:vim_packager_path)
endif

call plug#begin({
    \ 'dir': g:packager_path,
    \ 'default_plugin_type': 'opt',
    \ 'jobs': 0,
    \ })

Plug 'kristijanhusak/vim-packager'
" General {{{2
Plug 'chrisbra/Colorizer'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
Plug 'moll/vim-bbye'
Plug 'psliwka/vim-smoothie'

" Linters/formatters/runners {{{2
Plug 'dense-analysis/ale',
    \ {
    \  'for': ['fish', 'vim'],
    \  'pre': {-> plugins#ale#pre()},
    \ }
Plug 'sbdchd/neoformat',           {'on': 'Neoformat'}
Plug 'psf/black',                  {'branch': 'stable'}
Plug 'skywind3000/asyncrun.vim',   {'on': 'AsyncRun', 'post': {-> plugins#asyncrun#()}}
Plug 'skywind3000/asynctasks.vim',
    \ {
    \   'do': 'ln -sf $(pwd)/bin/asynctask ~/.local/bin',
    \   'on': 'AsyncTask',
    \ }
Plug 'kkoomen/vim-doge', {'type': 'start'}

" Editing behavior {{{2
" Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-surround'
" Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-unimpaired'
Plug 'machakann/vim-sandwich'
Plug 'tomtom/tcomment_vim', {'post': {-> plugins#tcomment#()}}
Plug 'justinmk/vim-sneak'
Plug 'rhysd/clever-f.vim'
Plug 'tommcdo/vim-lion'
Plug 'wellle/targets.vim'
Plug 'tommcdo/vim-exchange'
Plug 'bfredl/nvim-miniyank'
Plug 'antoinemadec/FixCursorHold.nvim'

" Explorer/finder utils {{{2
Plug 'junegunn/fzf',
    \ {
    \   'pre': function('plugins#fzf#()'),
    \   'post': {-> plugins#fzf#()},
    \   'do': './install --bin && ln -sf $(pwd)/bin/* ~/.local/bin && ln -sf $(pwd)/man/man1/* ~/.local/share/man/man1',
    \ }
Plug 'junegunn/fzf.vim'
Plug 'kevinhwang91/rnvimr',      {'do': 'pip3 install -U pynvim'}
Plug 'liuchengxu/vista.vim',     {'on': 'Vista'}
Plug 'liuchengxu/vim-clap',      {'on': 'Clap', 'do': ':Clap install-binary!'}
Plug 'laher/fuzzymenu.vim',      {'on': 'Fzm'}
Plug 'majutsushi/tagbar',        {'on': 'TagbarToggle'}
Plug 'mbbill/undotree',          {'on': 'UndotreeToggle'}
Plug 'preservim/nerdtree',       {'on': 'NERDTreeToggle'}
Plug 'Shougo/defx.nvim',         {'on': 'Defx'}
Plug 'kyazdani42/nvim-tree.lua', {'on': 'LuaTreeToggle'}
Plug 'justinmk/vim-dirvish',     {'type': 'start'}

function s:PickerPre()
    let g:picker_custom_find_executable = 'fd'
    let g:picker_custom_find_flags = '-t f -HL --color=never'
endfunction
let g:PickerPre = function('s:PickerPre')
Plug 'srstevenson/vim-picker',   {'on': ['<Plug>(PickerEdit)', '<Plug>(PickerVsplit)'], 'pre': g:PickerPre}
nmap <silent> <Leader>e <Plug>(PickerEdit)
nmap <silent> <Leader>v <Plug>(PickerVsplit)
Plug 'voldikss/vim-floaterm',    {'on': ['FloatermNew', 'FloatermToggle']}

" Vim Development {{{2
Plug 'tpope/vim-scriptease',         {'on': 'Messages'}
Plug 'mhinz/vim-lookup'
Plug 'tweekmonster/startuptime.vim', {'on': 'StartupTime'}
Plug 'dstein64/vim-startuptime'

" Editor appearance {{{2
Plug 'NLKNguyen/papercolor-theme'
Plug 'lifepillar/vim-gruvbox8'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/lib.kom'
Plug 'romgrk/barbar.nvim'

" Syntax/filetype {{{2
Plug 'vhdirk/vim-cmake'
Plug 'cespare/vim-toml',              {'type': 'start'}
Plug 'tbastos/vim-lua',               {'type': 'start'}
Plug 'blankname/vim-fish',            {'type': 'start'}
Plug 'vim-jp/syntax-vim-ex',          {'type': 'start'}
Plug 'dbeniamine/todo.txt-vim',       {'type': 'start'}
Plug 'SidOfc/mkdx',                   {'type': 'start'}
Plug 'habamax/vim-asciidoctor',       {'type': 'start'}
Plug 'masukomi/vim-markdown-folding', {'type': 'start'}

" Git {{{2
Plug 'airblade/vim-gitgutter', {'pre': {-> plugins#gitgutter#pre()}}
" Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'iberianpig/tig-explorer.vim', {'on': ['Tig', 'TigStatus']}

" Snippets {{{2
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'norcalli/snippets.nvim', {'if': has('nvim')}

" Language server/completion {{{2
Plug 'neovim/nvim-lspconfig',         {'if': has('nvim')}
Plug 'nvim-lua/lsp-status.nvim',      {'if': has('nvim')}
Plug 'nvim-lua/completion-nvim',      {'if': has('nvim')}
Plug 'nvim-lua/diagnostic-nvim',      {'if': has('nvim')}
Plug 'steelsojka/completion-buffers', {'if': has('nvim')}
Plug 'lifepillar/vim-mucomplete'
" Plug 'neoclide/coc.nvim', {'do': {-> coc#util#install()}}

" Lua/nvim {{{2
Plug 'bfredl/nvim-luadev',    {'if': has('nvim')}
Plug 'TravonteD/luajob',      {'if': has('nvim')}
Plug 'nvim-lua/plenary.nvim', {'if': has('nvim')}

" Training/Vim help {{{2
Plug 'tjdevries/train.nvim',     {'if': has('nvim')}
Plug 'liuchengxu/vim-which-key', {'on': ['WhichKey', 'WhichKeyVisual']}

" Tmux {{{2
Plug 'christoomey/vim-tmux-navigator'
Plug 'RyanMillerC/better-vim-tmux-resizer'
Plug 'comfortablynick/vim-tmux-runner'

" Initialize plugins {{{2
call plug#end()

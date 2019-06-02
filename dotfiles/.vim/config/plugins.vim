"   ____  _             _                 _
"  |  _ \| |_   _  __ _(_)_ __  _____   _(_)_ __ ___
"  | |_) | | | | |/ _` | | '_ \/ __\ \ / / | '_ ` _ \
"  |  __/| | |_| | (_| | | | | \__ \\ V /| | | | | | |
"  |_|   |_|\__,_|\__, |_|_| |_|___(_)_/ |_|_| |_| |_|
"                 |___/
"
" Common Vim/Neovim plugins

scriptencoding utf-8
" Helper functions/variables {{{1
" Vim-Plug Cond() {{{2
" Add conditions that aren't supported directly by vim-plug
function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

let g:vim_exists = executable('vim')

" Completion filetypes {{{2
let g:completion_filetypes = {
    \ 'deoplete':
    \   [
    \       'fish',
    \       'python',
    \   ],
    \ 'ycm':
    \   [
    \       'python',
    \       'javascript',
    \       'typescript',
    \       'cpp',
    \       'c',
    \       'go',
    \       'rust',
    \   ],
    \ 'coc':
    \   [
    \       'rust',
    \       'cpp',
    \       'c',
    \       'json',
    \       'go',
    \       'javascript',
    \       'typescript',
    \       'sh',
    \       'bash',
    \       'vim',
    \   ],
    \ }

" Packages {{{1
" Minpac Init {{{2
let minpac_path = expand('$HOME/.vim/pack/minpac/opt/minpac')
if empty(glob(minpac_path))
    echo 'Downloading Minpac'
    let clone = system('git clone https://github.com/k-takata/minpac.git ' . minpac_path)
endif

function! s:pack_init() abort
    packadd minpac
    if !exists('*minpac#init')
        echo "Minpac doesn't exist! Check download location"
        return
    endif
    command! -nargs=+ Pack call nick#minpac#add(<args>)
    call minpac#init()

    " General Packages {{{2
    Pack 'k-takata/minpac',              {'type': 'opt'}
    Pack 'tpope/vim-scriptease',         {'type': 'opt'}
    Pack 'mhinz/vim-lookup',             {'type': 'opt'}
    Pack 'NLKNguyen/papercolor-theme',   {'type': 'opt'}
    Pack 'scrooloose/nerdtree',          {'type': 'opt'}
    Pack 'chrisbra/Colorizer',           {'type': 'opt'}
    Pack 'mhinz/vim-startify'
    Pack 'scrooloose/nerdcommenter'
    Pack 'tpope/vim-surround'
    Pack 'tpope/vim-projectionist'
    Pack 'liuchengxu/vista.vim'
    Pack 'w0rp/ale'
    Pack 'sbdchd/neoformat'
    Pack 'mbbill/undotree'
    Pack 'majutsushi/tagbar'
    Pack 'skywind3000/asyncrun.vim'
    Pack 'vhdirk/vim-cmake'
    Pack 'junegunn/fzf'
    Pack 'junegunn/fzf.vim'
    Pack 'airblade/vim-rooter'
    Pack 'comfortablynick/eleline.vim'

    " Syntax highlighting {{{2
    Pack 'HerringtonDarkholme/yats'
    Pack 'gabrielelana/vim-markdown'
    Pack 'dag/vim-fish'
    Pack 'cespare/vim-toml'
    Pack 'chase/vim-ansible-yaml'
    Pack 'bfrg/vim-cpp-modern'

    " Git {{{2
    Pack 'airblade/vim-gitgutter',      {'type': 'opt'}
    Pack 'tpope/vim-fugitive',          {'type': 'opt'}
    Pack 'junegunn/gv.vim'

    " Snippets {{{2
    Pack 'Shougo/neosnippet.vim'
    Pack 'Shougo/neosnippet-snippets'
    Pack 'SirVer/ultisnips'
    Pack 'honza/vim-snippets'

    " Completion {{{2
    Pack 'neoclide/coc.nvim',
        \ {
        \   'type': 'opt',
        \   'do': '!yarn install --frozen-lockfile'
        \ }
        " \   'rev': '*',
        " \   'do': {-> coc#util#install()},
    Pack 'Shougo/deoplete.nvim',    {'type': 'opt'}
    Pack 'zchee/deoplete-jedi'
    Pack 'ponko2/deoplete-fish'

    " Tmux {{{2
    Pack 'christoomey/vim-tmux-navigator'
    Pack 'christoomey/vim-tmux-runner'
endfunction

" FileType Autocmds {{{2
" Don't load if we're using coc (use coc-git instead)
autocmd vimrc FileType *
    \ if index(g:completion_filetypes['coc'], &filetype) < 0
    \ | packadd vim-gitgutter
    \ | packadd vim-fugitive
    \ | endif

autocmd vimrc FileType *
    \ if index(g:completion_filetypes['deoplete'], &filetype) >= 0
    \ | packadd deoplete.nvim
    \ | packadd deoplete-jedi
    \ | packadd deoplete-fish
    \ | endif

" Pack commands {{{2
" Define commands for updating/cleaning the plugins.
command! PackUpdate call <SID>pack_init() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call <SID>pack_init() | call minpac#clean()
command! PackStatus call <SID>pack_init() | call minpac#status()
" Load :: use in vimrc files to load on startup
command! -nargs=+ -complete=packadd Load silent! packadd! <args>

" Load packages {{{1
Load eleline.vim
Load fzf
Load fzf.vim
Load nerdcommenter
Load tagbar
Load vista.vim
Load ale
Load neoformat
Load undotree
Load asyncrun.vim
Load vim-cmake

" Snippets
" Load ultisnips
Load vim-snippets

" Syntax
Load vim-cpp-modern
Load yats
Load vim-markdown
Load vim-fish
Load vim-toml
Load vim-ansible-yaml

" Tmux
Load vim-tmux-navigator
Load vim-tmux-runner

" vim:set fdm=marker fdl=1:

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
" function! Cond(cond, ...)
"     let opts = get(a:000, 0, {})
"     return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
" endfunction

let g:vim_exists = executable('vim')

" Completion filetypes {{{2
let g:completion_filetypes = {
    \ 'deoplete':
    \   [
    \       'fish',
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
    \       'python',
    \       'yaml',
    \   ],
    \ 'mucomplete':
    \   [
    \       'pro',
    \       'toml',
    \       'mail',
    \       'gitcommit',
    \       'txt',
    \       'ini',
    \       'muttrc',
    \       'markdown',
    \   ],
    \ }

" Exclude from default completion
let g:nocompletion_filetypes = [
    \ 'nerdtree',
    \ ]

" Packages {{{1
let g:use_nerdtree = 1                                          " Use NERDTree instead of netrw as explorer
" Minpac Init {{{2
if has('nvim')
    let minpac_path = expand('$XDG_DATA_HOME/nvim/site/pack/minpac/opt/minpac')
else
    let minpac_path = expand('$HOME/.vim/pack/minpac/opt/minpac')
endif
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
    if has('nvim')
        call minpac#init({'dir': expand('$XDG_DATA_HOME/nvim/site')})
    else
        call minpac#init({'dir': expand('$HOME/.vim')})
    endif

    " General Packages {{{2
    Pack 'k-takata/minpac'
    Pack 'tpope/vim-scriptease'
    Pack 'mhinz/vim-lookup'
    Pack 'scrooloose/nerdtree'
    Pack 'chrisbra/Colorizer'
    Pack 'mhinz/vim-startify'
    Pack 'scrooloose/nerdcommenter'
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
    Pack 'comfortablynick/eleline.vim'
    Pack 'freitass/todo.txt-vim'
    Pack 'justinmk/vim-sneak'
    Pack 'embear/vim-localvimrc'
    Pack 'liuchengxu/vim-clap'

    " Themes {{{2
    Pack 'NLKNguyen/papercolor-theme'
    Pack 'gruvbox-community/gruvbox'

    " Syntax highlighting {{{2
    if has('nvim')
        " Python
        Pack 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
    endif
    Pack 'HerringtonDarkholme/yats'
    Pack 'gabrielelana/vim-markdown'
    Pack 'dag/vim-fish'
    Pack 'cespare/vim-toml'
    Pack 'bfrg/vim-cpp-modern'
    Pack 'vim-jp/syntax-vim-ex'
    Pack 'pearofducks/ansible-vim'

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
    if has('nvim')
        Pack 'neoclide/coc.nvim',
            \ { 'do': 'split term://yarn install --frozen-lockfile' }
    endif
    Pack 'Shougo/deoplete.nvim',    {'type': 'opt'}
    Pack 'lifepillar/vim-mucomplete'
    Pack 'zchee/deoplete-jedi'
    Pack 'ponko2/deoplete-fish'

    " Tmux {{{2
    Pack 'christoomey/vim-tmux-navigator'
    Pack 'christoomey/vim-tmux-runner'
endfunction

" Local plugins {{{2
" Have to add to rtp manually
" set runtimepath+=~/git/eleline.vim

" FileType Autocmds {{{2
" Don't load if we're using coc (use coc-git instead)
autocmd vimrc FileType *
    \ if index(g:completion_filetypes['coc'], &filetype) < 0
    \ | packadd vim-gitgutter
    \ | endif

autocmd vimrc FileType *
    \ if index(g:completion_filetypes['deoplete'], &filetype) >= 0
    \ | packadd deoplete.nvim
    \ | packadd deoplete-jedi
    \ | packadd deoplete-fish
    \ | endif

" Pack commands {{{2
" Define commands for updating/cleaning the plugins.
command! PackUpdate call <SID>pack_init() | call nick#minpac#update_all()
command! PackClean  call <SID>pack_init() | call minpac#clean()
command! PackStatus call <SID>pack_init() | call minpac#status()
" Load :: use in vimrc files to load on startup
command! -nargs=+ -complete=packadd Load silent! packadd! <args>

" Load packages {{{1
" if !&diff
    Load eleline.vim
" endif
Load fzf
Load fzf.vim
Load nerdcommenter
Load tagbar
Load vista.vim
Load ale
Load neoformat
Load undotree
Load asyncrun.vim
Load vim-sneak
Load vim-fugitive
Load vim-surround
Load vim-localvimrc
Load vim-clap

" Snippets
" Load ultisnips
Load vim-snippets

" Syntax
Load vim-cpp-modern
Load vim-markdown
Load ansible-vim
Load semshi

" Tmux
Load vim-tmux-runner
Load vim-tmux-navigator

" vim:set fdm=marker fdl=1:

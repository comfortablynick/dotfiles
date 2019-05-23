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

" Plugin definitions {{{1
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
    command! -nargs=+ Pack call minpac#add(<args>)
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
    " Pack 'Shougo/echodoc'
    Pack 'skywind3000/asyncrun.vim'
    Pack 'vhdirk/vim-cmake'
    Pack 'junegunn/fzf'
    Pack 'junegunn/fzf.vim'
    Pack 'comfortablynick/eleline.vim'

    " Syntax highlighting {{{2
    Pack 'HerringtonDarkholme/yats'
    Pack 'gabrielelana/vim-markdown'
    Pack 'dag/vim-fish'
    Pack 'cespare/vim-toml'
    Pack 'chase/vim-ansible-yaml'

    " Git {{{2
    Pack 'airblade/vim-gitgutter',      {'type': 'opt'}
    Pack 'tpope/vim-fugitive',          {'type': 'opt'}
    Pack 'junegunn/gv.vim'

    Pack 'Shougo/neosnippet.vim'
    Pack 'Shougo/neosnippet-snippets'
    Pack 'honza/vim-snippets'

    Pack 'bfrg/vim-cpp-modern'
    Pack 'neoclide/coc.nvim',
        \ {
        \   'type': 'opt',
        \   'do': '!yarn install --frozen-lockfile'
        \ }

    " Deoplete
    Pack 'Shougo/deoplete.nvim',    {'type': 'opt'}
    " Pack 'tweekmonster/deoplete-clang2'
    " Pack 'Shougo/neco-vim',
    Pack 'zchee/deoplete-jedi'
    Pack 'ponko2/deoplete-fish'

    Pack 'christoomey/vim-tmux-navigator'
    Pack 'christoomey/vim-tmux-runner'
endfunction

" Pack autocmds {{{3
" Don't load if we're using coc (use coc-git instead)
autocmd vimrc FileType *
    \ if index(g:completion_filetypes['coc'], &filetype) < 0
    \ | packadd vim-gitgutter
    \ | packadd vim-fugitive
    \ | endif

" Pack commands {{{3
" Define commands for updating/cleaning the plugins.
command! PackUpdate call <SID>pack_init() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call <SID>pack_init() | call minpac#clean()
command! PackStatus call <SID>pack_init() | call minpac#status()

let g:eleline_background = 234

" Plugin configuration {{{1
" Echodoc {{{2
" TODO: Only execute for python/ts/js?
" let g:echodoc#enable_at_startup = 1
" let g:ecodoc#type = 'echo'                   " virtual: virtualtext; echo: use command line echo area

" Neosnippet {{{2
" if exists('g:loaded_neosnippet')
"     let g:neosnippet#enable_completed_snippet = 1
"     autocmd vimrc CompleteDone * call neosnippet#complete_done()
" endif

" vim:set fdl=1:

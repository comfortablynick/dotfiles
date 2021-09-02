" Use this for testing plugins
" vint: -ProhibitSetNoCompatible
set nocompatible
set shell=/bin/sh
set runtimepath=$VIMRUNTIME
set packpath=$VIMRUNTIME
syntax on
filetype plugin indent on

" Non-essential mappings and settings so I don't annoy myself {{{
set tabstop=4
set shiftwidth=0 
set expandtab
set number
set background=dark
set laststatus=2
set ruler
set wildmenu
nnoremap ; :
xnoremap ; :
onoremap ; :
nnoremap g: g;
nnoremap @; @:
nnoremap q; q:
xnoremap q; q:
inoremap kj <Esc>`^
" }}}

" vim-plug setup
let g:temp_dir      = '/tmp/nvim/'
let g:vim_plug_file = g:temp_dir .. 'plug.vim'
let g:vim_plug_dir  = g:temp_dir .. 'plugged'

if !filereadable(g:vim_plug_file)
    call system(['curl', '-fLo', g:vim_plug_file, '--create-dirs',
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'])
endif

source `=g:vim_plug_file`
call plug#begin(g:vim_plug_dir)
Plug 'liuchengxu/vim-clap', { 'do': { -> clap#installer#force_download() } }
call plug#end()

PlugClean! | PlugUpdate --sync | close

let g:clap_preview_direction = 'UD'

let s:fname = { v -> split(v, ' ')[-1] }
let g:clap_provider_scriptnames = {
    \ 'id': 'scriptnames',
    \ 'description': 'View output of `:scriptnames`',
    \ 'source':  { -> split(execute('scriptnames'), '\n') },
    \ 'on_move': { -> clap#preview#file(s:fname(g:clap.display.getcurline())) },
    \ 'sink':    { v -> execute('edit ' .. s:fname(v)) },
    \ 'syntax':  'clap_scriptnames',
    \ }

let g:clap_provider_quick_open = {
    \ 'id': 'quick_open',
    \ 'description': 'Open dotfiles',
    \ 'source':  ['~/.vimrc', '~/.bashrc', '~/.zshrc', '~/.envrc'],
    \ 'sink':    'e',
    \ 'on_move': {->clap#preview#file(g:clap.display.getcurline())},
    \ }

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
    let s:bootstrap = v:true
    call system(['curl', '-fLo', g:vim_plug_file, '--create-dirs',
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'])
endif

source `=g:vim_plug_file`
call plug#begin(g:vim_plug_dir)

Plug 'liuchengxu/vim-clap', { 'do': ':call clap#installer#force_download()' }
Plug 'NLKNguyen/papercolor-theme'

call plug#end()

if exists('s:bootstrap')
    PlugClean! | PlugUpdate --sync | close
endif

let g:clap_preview_direction = 'LR'

let s:fname = { v -> split(v, ' ')[-1] }
let s:on_move_async = {->clap#client#call_preview_file({'fpath': s:fname(g:clap.display.getcurline())})}

let g:clap_provider_scriptnames = {
    \ 'id': 'scriptnames',
    \ 'description': 'View output of `:scriptnames`',
    \ 'source':  { -> split(execute('scriptnames'), '\n') },
    \ 'sink':    { v -> execute('edit ' .. s:fname(v)) },
    \ 'on_move_async': s:on_move_async,
    \ 'syntax':  'clap_scriptnames',
    \ }

" let g:clap_provider_quick_open = {
"     \ 'id': 'quick_open',
"     \ 'description': 'Open dotfiles',
"     \ 'source':  ['~/.vimrc', '~/.bashrc', '~/.zshrc', '~/.envrc'],
"     \ 'sink':    'e',
"     \ 'on_move': {->clap#preview#file(g:clap.display.getcurline())},
"     \ 'on_move_async': {->clap#client#call_preview_file(v:null)},
"     \ }
let g:clap_provider_quick_open = {
    \ 'source':  ['0 ~/.vimrc', '1 ~/.bashrc', '2 ~/.zshrc', '3 ~/.config/nvim/init.lua'],
    \ 'sink':    { v -> execute('edit ' .. s:fname(v)) },
    \ 'on_move_async': s:on_move_async,
    \ }

colorscheme PaperColor

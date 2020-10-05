" Minimal vimrc
" Use to debug config

" vint: -ProhibitSetNoCompatible
set nocompatible
let g:python3_host_prog = $NVIM_PY3_DIR

set runtimepath=$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after
" set runtimepath^=~/vim-test
let &packpath=&runtimepath

filetype plugin indent on
syntax enable

" Minimal vimrc
" Use to debug config

" vint: -ProhibitSetNoCompatible
set nocompatible
set runtimepath=$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after

" Install plugins in ~/vim-test/pack/*/[opt|start]
set runtimepath^=~/vim-test
let &packpath=&runtimepath

filetype plugin indent on
syntax enable

function! Test() abort
    return
endfunction

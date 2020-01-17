" ====================================================
" Filename:    after/ftplugin/cmake.vim
" Description: CMake file setting overrides
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-17 13:15:29 CST
" ====================================================
if exists('g:loaded_ftplugin_cmake_0zr1ugnw') | finish | endif
let g:loaded_ftplugin_cmake_0zr1ugnw = 1

setlocal shiftwidth=2 tabstop=2
setlocal makeprg=cmakelint\ --config=$XDG_CONFIG_HOME/cmake/cmakelintrc\ %
setlocal formatprg=cmake-format\ -c\ $XDG_CONFIG_HOME/cmake/cmake-format.py\ %

let b:neoformat_run_all_formatters = 0

" ====================================================
" Filename:    plugin/commands.vim
" Description: General commands
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-19 23:00:33 CST
" ====================================================
if exists('g:loaded_plugin_commands') | finish | endif
let g:loaded_plugin_commands = 1

" Floating help window
command! -complete=help -nargs=? Help lua require'window'.floating_help(<q-args>)
command! -complete=help -nargs=? H Help <args>

command! -complete=file -bang -nargs=? Run lua require'tools'.async_run(<q-args>, <bang>)

" Save if file has changed and reload vimrc
command! S update | source $MYVIMRC
" Easily change background
command! Light set background=light
command! Dark  set background=dark
" Lua async grep
command! -nargs=+ -complete=dir -bar Grep
    \ lua require'tools'.async_grep(<q-args>)
" Delete buffer without changing window layout
command! -bang -complete=buffer -nargs=? Bclose
    \ packadd vim-bbye | Bdelete<bang> <args>

" Commonly mistyped commands
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w

" Lazy load startuptime.vim plugin
command! -nargs=* -complete=file StartupTime
    \ packadd startuptime.vim | StartupTime <args>

" Lazy load scriptease plugin
command! -bar Messages
    \ packadd vim-scriptease | Messages

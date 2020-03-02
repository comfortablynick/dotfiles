" ====================================================
" Filename:    plugin/commands.vim
" Description: General commands
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-29 01:03:43 CST
" ====================================================
let s:guard = 'g:loaded_plugin_commands' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" General {{{1
" S :: save if file has changed and reload vimrc {{{2
command! S update | source $MYVIMRC

" Light/Dark :: easily change background {{{2
command! Light set background=light
command! Dark  set background=dark

" Bclose :: delete buffer without changing window layout {{{2
command! -bang -complete=buffer -nargs=? Bclose
    \ packadd vim-bbye | Bdelete<bang> <args>

" UndotreeToggle :: lazy load undotree when first called {{{2
command! UndotreeToggle packadd undotree|UndotreeToggle|UndotreeFocus

" Misc commonly mistyped commands {{{2
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w

" Lua {{{1
" [H]elp :: floating help window {{{2
command! -complete=help -nargs=? Help lua require'window'.floating_help(<q-args>)
cnoreabbrev <expr> H util#cabbr('H', 'Help')

" [F]loat[T]erm :: floating terminal window {{{2
command! -complete=file -nargs=+ FloatTerm lua require'window'.float_term(<q-args>, 50)
cnoreabbrev <expr> FT util#cabbr('FT', 'FloatTerm')

" Run :: run a command asynchronously {{{2
command! -complete=file -bang -nargs=+ Run lua require'tools'.async_run(<q-args>, '<bang>')
cnoreabbrev <expr> R util#cabbr('R', 'Run')

" Cmd :: test version of async command run {{{2
command! -complete=file -bang -nargs=+ Cmd lua require'tools'.run(<q-args>)

" Grep :: async grep {{{2
command! -nargs=+ -complete=dir -bar Grep lua require'tools'.async_grep(<q-args>)

" Utilities {{{1
" StartupTime :: lazy load startuptime.vim plugin {{{2
command! -nargs=* -complete=file StartupTime
    \ packadd startuptime.vim | StartupTime <args>

" Scriptease :: lazy load vim-scriptease plugin {{{2
command! -bar Messages
    \ packadd vim-scriptease | Messages

" Redir :: send output of <expr> to scratch window {{{2
" Usage:
" 	:Redir hi .........show the full output of command ':hi' in a scratch window
" 	:Redir !ls -al ....show the full output of command ':!ls -al' in a scratch window
command! -nargs=1 -complete=command Redir silent call util#redir(<q-args>)

" Scriptnames :: display :scriptnames in quickfix and optionally filter {{{2
command! -nargs=* -bar -count=0 Scriptnames
    \ call quickfix#scriptnames(<f-args>) |
    \ copen |
    \ <count>

" Pretty-printing {{{2
" Using Lua vim.inspect()
command! -complete=var -nargs=1 LPrint echo v:lua.vim.inspect(<args>)
" Using python pformat (handles lists better)
command! -complete=var -nargs=1 PPrint echo util#pformat(<args>)

" vim:fdl=1:

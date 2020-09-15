" ====================================================
" Filename:    plugin/commands.vim
" Description: General commands
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
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
command! UndotreeToggle packadd undotree | UndotreeToggle | UndotreeFocus
noremap <silent> <F5> :UndotreeToggle<CR>

" Scratch :: create scratch window; add ! to vsplit {{{2
command! -bang -bar Scratch call window#create_scratch(<bang>0)

" [Async]Run :: run a command asynchronously {{{2
cnoreabbrev <expr> R map#cabbr('R', 'Run')
cnoreabbrev <expr> grep map#cabbr('grep', 'Grep')

" Lazy load AsyncRun
command! -bang -nargs=+ -range=0 -complete=file AsyncRun
    \ packadd asyncrun.vim
    \ | call asyncrun#run('<bang>', '', <q-args>, <count>, <line1>, <line2>)

command! -bang -nargs=+ -range=0 -complete=file Run
    \ packadd asyncrun.vim
    \ | call asyncrun#run('<bang>', '', <q-args>, <count>, <line1>, <line2>)

" Use AyncRun for Make
command! -bang -nargs=* -complete=file Make
    \ AsyncRun -program=make @ <args>

" Async grep
command! -nargs=+ -complete=file_in_path -bar Grep
    \ AsyncRun -strip -program=grep <args>

" AsyncTasks :: run defined tasks asynchronously {{{2
command! -bang -nargs=* -range=0 AsyncTask
    \ packadd asynctasks.vim
    \ | call asynctasks#cmd('<bang>', <q-args>, <count>, <line1>, <line2>)

" GV :: git commit viewer {{{2
command! -bang -nargs=* -range=0 GV
    \ packadd gv.vim | GV<bang> <args>

" LazyGit :: tui for git {{{2
command! -nargs=* LazyGit call plugins#floaterm#wrap('lazygit', <f-args>)

" LGrep :: location list grep {{{2
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr s:grep(<f-args>)

function! s:grep(...) abort
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

" Fzm :: lazy load fuzzymenu.vim {{{2
command! -bang -nargs=0 Fzm
    \ call plugins#lazy_run('Fzm', 'fuzzymenu.vim', {'bang': '<bang>'})
nnoremap <C-P> :Fzm<CR>

" Neoformat :: lazy load neoformat {{{2
command! -nargs=0 Neoformat call plugins#lazy_run('Neoformat', 'neoformat')
noremap <silent> <F3> :Neoformat<CR>

" Rooter :: Find project root {{{2
command! -nargs=0 Rooter call plugins#lazy_run('Rooter', 'vim-rooter')

" Misc commonly mistyped commands {{{2
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w

" Utilities {{{1
" StartupTime :: lazy load startuptime.vim plugin {{{2
command! -nargs=* -complete=file StartupTime call plugins#lazy_run('StartupTime', 'startuptime.vim')

" Scriptease :: lazy load vim-scriptease plugin {{{2
command! Messages call plugins#lazy_run('Messages', 'vim-scriptease')

" Redir :: send output of <expr> to scratch window {{{2
" Usage:
"   :Redir hi .........show the full output of command ':hi' in a scratch window
"   :Redir !ls -al ....show the full output of command ':!ls -al' in a scratch window
command! -nargs=1 -complete=command Redir silent call util#redir(<q-args>)

" Scriptnames :: display :scriptnames in quickfix and optionally filter {{{2
command! -nargs=* -bar -count=0 Scriptnames
    \ call quickfix#scriptnames(<f-args>) |
    \ call quickfix#open() |
    \ <count>

" Pretty-printing {{{2
" nvim: Using Lua vim.inspect()
if has('nvim')
    command! -complete=var -nargs=1 LPrint echo v:lua.vim.inspect(<args>)
endif

" Using python pformat (handles lists better)
command! -complete=var -nargs=1 PPrint echo util#pformat(<args>)

" nvim-only after this line {{{1
" [H]elp :: floating help window {{{2
if !has('nvim') | finish | endif
command! -complete=help -nargs=? Help lua require'window'.floating_help(<q-args>)
cnoreabbrev <expr> H map#cabbr('H', 'Help')

" [F]loat[T]erm :: floating terminal window {{{2
command! -complete=file -nargs=+ FloatTerm lua require'window'.float_term(<q-args>, 50)
cnoreabbrev <expr> FT map#cabbr('FT', 'FloatTerm')

" Cmd :: test version of lua async command run {{{2
command! -complete=file -bang -nargs=+ Cmd lua require'tools'.run(<q-args>)
" command! -complete=file -bang -nargs=+ Run lua require'tools'.async_run(<q-args>, '<bang>')

" MRU :: most recently used files {{{2
command! -nargs=? MRU lua require'window'.create_scratch(require'tools'.mru_files(<args>))

" Grep :: async grep {{{2
command! -nargs=+ -complete=file -bar Grep lua require'tools'.async_grep(<q-args>)

" Make :: async make {{{2
command! -nargs=0 -complete=file Make lua require'tools'.make()

" vim:fdl=1 noml:

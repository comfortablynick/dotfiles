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
command! S update | silent! unlet {s:guard} | source $MYVIMRC

" Light/Dark :: easily change background {{{2
command! Light set background=light
command! Dark  set background=dark

" Bclose :: delete buffer without changing window layout {{{2
command! -bang -complete=buffer -nargs=? Bclose
    \ call plugins#lazy_run('Bdelete', 'vim-bbye',
    \ {'bang': '<bang>', 'args': '<args>'})

" UndotreeToggle :: lazy load undotree when first called {{{2
command! UndotreeToggle packadd undotree | UndotreeToggle | UndotreeFocus
noremap <silent> <F5> :UndotreeToggle<CR>

" Scratch[ify] :: convert to scratch buffer or create scratch window {{{2
command! Scratchify setlocal nobuflisted noswapfile buftype=nofile bufhidden=delete
command! -nargs=* -complete=command Scratch call window#open_scratch(<q-mods>, <q-args>)

" [Async]Run :: run a command asynchronously {{{2
call map#set_cabbr('R', 'AsyncRun')
call map#set_cabbr('grep', 'silent grep!')

" Lazy load AsyncRun
command! -bang -nargs=+ -range=0 -complete=file AsyncRun
    \ call plugins#lazy_run(
    \   {-> asyncrun#run('<bang>', '', <q-args>, <count>, <line1>, <line2>)},
    \   'asyncrun.vim'
    \ )

" Use AyncRun for Make
command! -bang -nargs=* -complete=file Make
    \ AsyncRun -program=make @ <args>

" Async grep
command! -nargs=+ -complete=file_in_path -bar Grep
    \ AsyncRun -strip -program=grep <args>

" AsyncTasks :: run defined tasks asynchronously {{{2
command! -bang -nargs=* -range=0 AsyncTask
    \ call plugins#lazy_run(
    \ {-> asynctasks#cmd('<bang>', <q-args>, <count>, <line1>, <line2>)},
    \ 'asynctasks.vim'
    \ )

" GV :: git commit viewer {{{2
command! -bang -nargs=* -range=0 GV
    \ call plugins#lazy_run('GV', 'gv.vim',
    \   {'bang': '<bang>', 'args': '<args>'})

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

call map#set_cabbr('ehco', 'echo')

" Utilities {{{1
" StartupTime :: lazy load startuptime.vim plugin {{{2
command! -nargs=* -complete=file StartupTime call plugins#lazy_run('StartupTime', 'startuptime.vim')
command! -nargs=* -complete=file Startup
    \ call plugins#lazy_run(
    \   'StartupTime',
    \   'vim-startuptime',
    \   {'before': 'silent! delcommand StartupTime'}
    \ )

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
    \ copen 20 |
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
call map#set_cabbr('H', 'Help')

" LspDisable :: stop active lsp clients {{{2
" command! Lsp

" Cmd :: test version of lua async command run {{{2
command! -complete=file -bang -nargs=+ Cmd lua require'tools'.run(<q-args>)
" command! -complete=file -bang -nargs=+ Run lua require'tools'.async_run(<q-args>, '<bang>')

" MRU :: most recently used files {{{2
command! -nargs=? MRU lua require'window'.create_scratch(require'tools'.mru_files(<args>, <mods>))

" Grep :: async grep {{{2
command! -nargs=+ -complete=file -bar Grep lua require'tools'.async_grep(<q-args>)

" Make :: async make {{{2
" command! -nargs=0 -complete=file Make lua require'tools'.make()

" vim:fdl=1:

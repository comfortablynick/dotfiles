" General commands/aliases {{{1
" S :: save if file has changed and re-run {{{2
" Use asynctasks task runner to determine command based on filetype
"
" Can't use plugins#lazy_run here because it will try to overwrite itself
" while running. Manually packadd on demand or packadd[!] somewhere else
command S update | packadd asynctasks.vim | AsyncTask file-run

" Light/Dark :: easily change background {{{2
command! Light set background=light
command! Dark  set background=dark

" Bdelete :: delete buffer without changing window layout {{{2
" command! -bang -complete=buffer -nargs=? Bclose
"     \ call plugins#lazy_run('Bdelete', 'vim-bbye',
"     \ {'bang': '<bang>', 'args': '<args>'})
command -nargs=? -complete=buffer Bdelete call buffer#sayonara(v:true)

" UndotreeToggle :: lazy load undotree when first called {{{2
command! UndotreeToggle
    \ call plugins#lazy_run('UndotreeToggle<bar>UndotreeFocus', 'undotree')
noremap <silent> <F5> :UndotreeToggle<CR>

" Scratch[ify] :: convert to scratch buffer or create scratch window {{{2
command! Scratchify setlocal nobuflisted noswapfile buftype=nofile bufhidden=delete
command! -nargs=* -complete=command Scratch call window#open_scratch(<q-mods>, <q-args>)

" LGrep :: location list grep {{{2
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr s:grep(<f-args>)

function! s:grep(...)
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

" h[g] :: Open help[grep] in new or existing tab {{{2
cnoreabbrev <expr> h
    \ map#cabbr('h', {->window#tab_mod('help', 'help')})
cnoreabbrev <expr> hg
    \ map#cabbr('hg', {->window#tab_mod('helpgrep', 'help')})

" vh :: Open help in vert split {{{2
Alias vh vert\ help

" man :: Open :Man in new or existing tab {{{2
cnoreabbrev <expr> man
    \ map#cabbr('man', {->window#tab_mod('Man', 'man')})

" fff :: Insert comment with fold marker {{{2
inoreabbrev fff <C-R>=syntax#foldmarker()<CR><C-R>=map#eatchar('\s')<CR>

" Misc commonly mistyped commands {{{2
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w

Alias ehco echo

" Misc command abbreviations {{{2
Alias grep silent\ grep!

" AsyncRun/AsyncTasks {{{1
" AsyncRun :: lazy load plugin {{{2
command! -bang -nargs=+ -range=0 -complete=file AsyncRun
    \ call plugins#lazy_run(
    \   {-> asyncrun#run('<bang>', '', <q-args>, <count>, <line1>, <line2>)},
    \   'asyncrun.vim'
    \ )
Alias R AsyncRun

" Make :: async make {{{2
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" Grep :: async grep {{{2
command! -nargs=+ -complete=file_in_path -bar Grep
    \ AsyncRun -strip -program=grep <args>

" AsyncTask :: lazy load plugin {{{2
command! -bang -nargs=* -range=0 AsyncTask
    \ call plugins#lazy_run(
    \ {-> asynctasks#cmd('<bang>', <q-args>, <count>, <line1>, <line2>)},
    \ 'asynctasks.vim'
    \ )

" Git {{{1
" GV :: git commit viewer {{{2
command! -bang -nargs=* -range=0 GV
    \ call plugins#lazy_run('GV', 'gv.vim',
    \   {'bang': '<bang>', 'args': '<args>'})

" Gpush :: custom git push {{{2
command Gpush lua require'tools'.term_run({cmd = "git push", mods = "10"})
nnoremap <silent><Leader>gp :Gpush<CR>

" Tig[Status] :: view tig in terminal {{{2
command! Tig       call plugins#lazy_run('Tig', 'tig-explorer.vim')
command! TigStatus call plugins#lazy_run('TigStatus', 'tig-explorer.vim')
Alias Ts TigStatus
nnoremap <silent><Leader>ts :TigStatus<CR>

" LazyGit :: tui for git {{{2
command -bang -nargs=* LazyGit
    \ call floaterm#run('new', <bang>0, '--width=0.9', '--height=0.6', 'lazygit')

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
command! -nargs=* -complete=var PP
    \ call plugins#lazy_run(
    \ 'echo scriptease#dump('..<q-args>..', #{width: 60})',
    \ 'vim-scriptease'
    \ )

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

" WhichKey[Visual] :: display key maps {{{2
command! -nargs=1 WhichKey
    \ call plugins#lazy_run(
    \   'WhichKey',
    \   'vim-which-key',
    \   {'args': <q-args>, 'bang': '<bang>'}
    \ )

command! -nargs=1 WhichKeyVisual
    \ call plugins#lazy_run(
    \   'WhichKeyVisual',
    \   'vim-which-key',
    \   {'args': <q-args>, 'bang': '<bang>'}
    \ )

" Map WhichKey to g:mapleader
execute 'nnoremap <silent> <Leader> :<c-u>WhichKey "'..get(g:, 'mapleader', ',')..'"<CR>'

" Pretty-printing {{{2
" nvim: Using Lua vim.inspect()
if has('nvim')
    command! -complete=var -nargs=1 LPrint echo v:lua.vim.inspect(<args>)
endif

" Using python pformat (handles lists better)
command! -complete=var -nargs=1 PPrint echo util#pformat(<args>)

" nvim-only {{{1
if has('nvim')
    " Lua modules {{{2
    let s:tools = v:lua.require('tools')
    let s:buffer = v:lua.require('buffer')
    let s:window = v:lua.require('window')
    let s:grep = v:lua.require('grep')

    " [H]elp :: floating help window {{{2
    command! -complete=help -nargs=? Help call s:window.floating_help(<q-args>)
    Alias H Help

    " Colorizer :: run nvim-colorizer.lua {{{2
    " command Colorizer call plugins#lazy_run('ColorizerToggle', 'nvim-colorizer.lua')
    command Colorizer packadd nvim-colorizer.lua | lua require'colorizer'.attach_to_buffer{0, {mode = "foreground"}}

    " LspDisable :: stop active lsp clients {{{2
    " command! Lsp

    " Lua {{{2
    Alias l lua
    cnoreabbrev <expr> lp
        \ map#cabbr('lp', 'lua p()<Left><C-R>=map#eatchar(''\s'')<CR>')

    " Term :: Run async command in terminal buffer {{{2
    command -complete=file -nargs=+ Term call s:tools.term_run_cmd(<f-args>)

    " Sh :: Run async command in shell and output to scratch buffer {{{2
    command -complete=file -nargs=+ Sh call s:tools.sh({'cmd': <q-args>})

    " Run :: lua version of AsyncRun {{{2
    command -complete=file -bang -nargs=+ Run call s:tools.async_run(<q-args>, '<bang>')

    " MRU :: most recently used files {{{2
    command -nargs=? MRU call s:window.create_scratch(s:tools.mru_files(<args>), '<mods>')

    " Redir :: send output of <expr> to scratch window {{{2
    " Usage:
    "   :Redir hi .........show the full output of command ':hi' in a scratch window
    "   :Redir !ls -al ....show the full output of command ':!ls -al' in a scratch window
    command! -nargs=1 -complete=command Redir call s:tools.redir({'cmd': <q-args>, 'mods': '<mods>'})

    " Grep :: async grep {{{2
    command! -nargs=+ -complete=file -bar Grep call s:grep.grep_for_string(<q-args>)

    " Make :: async make {{{2
    command! -nargs=0 -complete=file Make call s:tools.make()

    " BufOnly :: keep only current buffer (! forces close) {{{2
    command -bang BufOnly call s:buffer.only(<bang>0)
endif

" vim:fdl=1:

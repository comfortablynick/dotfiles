" General commands/aliases {{{1
" S :: save if file has changed and re-run {{{2
" Use asynctasks task runner to determine command based on filetype
command S AsyncTask file-run

" Light/Dark :: easily change background {{{2
command Light set background=light
command Dark  set background=dark

" Bdelete[!] :: delete buffer without changing window layout {{{2
" With [!], do not preserve window layout
command -bang -nargs=? -complete=buffer Bdelete call buffer#sayonara(<bang>0)

" BufOnly[!] :: keep only current buffer (! forces close) {{{2
command -bang BufOnly call buffer#only({'bang': <bang>0})

" Bclose[!] :: close buffers with common options
" TODO: does this take the place of BufOnly?
command -nargs=1 -bang -complete=customlist,buffer#close_complete
    \ Bclose call buffer#close(<bang>0, <q-args>)

" UndotreeToggle :: lazy load undotree when first called {{{2
" command! UndotreeToggle
"     \ call plugins#lazy_run('UndotreeToggle<bar>UndotreeFocus', 'undotree')
" noremap <F5> <Cmd>UndotreeToggle<CR>

" Scratch[ify] :: convert to scratch buffer or create scratch window {{{2
command Scratchify setlocal nobuflisted noswapfile buftype=nofile bufhidden=delete
command -nargs=* -complete=command Scratch call window#open_scratch(<q-mods>, <q-args>)

" StripWhiteSpace :: remove trailing whitespace {{{2
command StripWhiteSpace call util#preserve('%s/\s\+$//e')

" LGrep :: location list grep {{{2
command -nargs=+ -complete=file_in_path -bar LGrep lgetexpr s:grep(<f-args>)

function s:grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

" Fzm :: lazy load fuzzymenu.vim {{{2
" command! -bang Fzm
"     \ call plugins#lazy_run('Fzm', 'fuzzymenu.vim', {'bang': '<bang>'})

" Neoformat :: lazy load neoformat {{{2
" command! Neoformat call plugins#lazy_run('Neoformat', 'neoformat')
noremap <F3> <Cmd>Neoformat<CR>

" Rooter :: Find project root {{{2
" command! Rooter call plugins#lazy_run('Rooter', 'vim-rooter')

" h[g] :: Open help[grep] in new or existing tab {{{2
call map#cabbr('h', function('window#tab_mod', ['help', 'help']))
call map#cabbr('hg', function('window#tab_mod', ['helpgrep', 'help']))

" vh :: Open help in vert split {{{2
call map#cabbr('vh', 'vert help')

" pyp :: Python3 print {{{2
call map#cabbr('pyp', 'py3 print()<Left><C-R>=map#eatchar(''\s'')<CR>')

" man :: Open :Man in new or existing tab {{{2
call map#cabbr('man', function('window#tab_mod', ['Man', 'man']))

" [v|h]t :: Open vertical or horizontal split terminal
call map#cabbr('vt', 'vsplit \| terminal')
call map#cabbr('ht', 'split \| terminal')

" fff :: Insert comment with fold marker {{{2
inoreabbrev fff <C-R>=syntax#foldmarker()<CR><C-R>=map#eatchar('\s')<CR>

" Misc commonly mistyped commands {{{2
command WQ wq
command Wq wq
command Wqa wqa
command W w

call map#cabbr('ehco', 'echo')

" Misc command abbreviations {{{2
call map#cabbr('grep', 'silent grep!')
call map#cabbr('make', 'silent make!')

" AsyncRun/AsyncTasks {{{1
" AsyncRun :: lazy load plugin {{{2
" command! -bang -nargs=+ -range=0 -complete=file AsyncRun
"     \ call plugins#lazy_run(
"     \   {-> asyncrun#run('<bang>', '', <q-args>, <count>, <line1>, <line2>)},
"     \   'asyncrun.vim'
"     \ )
call map#cabbr('R', 'AsyncRun')

" Make :: async make {{{2
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" Grep :: async grep {{{2
command! -nargs=+ -complete=file_in_path -bar Grep
    \ AsyncRun -strip -program=grep <args>

" AsyncTask :: task runner integrated with asyncrun {{{2
" if !exists(':AsyncTask')
"     " Lazy load if we haven't loaded the plugin
"     command -bang -nargs=* -range=0 AsyncTask
"         \ call plugins#lazy_run(
"         \ {-> asynctasks#cmd('<bang>', <q-args>, <count>, <line1>, <line2>)},
"         \ 'asynctasks.vim'
"         \ )
" endif
call map#cabbr('ta', 'AsyncTask')
nnoremap <Leader>r <Cmd>AsyncTask file-run<CR>
nnoremap <Leader>b <Cmd>AsyncTask file-build<CR>

" Git {{{1
" GV :: git commit viewer {{{2
" command! -bang -nargs=* -range=0 GV
"     \ call plugins#lazy_run('GV', 'gv.vim',
"     \   {'bang': '<bang>', 'args': '<args>'})

" Gpush :: custom git push {{{2
command Gpush lua require'tools'.term_run({cmd = "git push", mods = "10"})
nnoremap <Leader>gp <Cmd>Gpush<CR>

" Tig[Status] :: view tig in terminal {{{2
" command! Tig       call plugins#lazy_run('Tig', 'tig-explorer.vim')
" command! TigStatus call plugins#lazy_run('TigStatus', 'tig-explorer.vim')
call map#cabbr('ts', 'TigStatus')

" LazyGit :: tui for git {{{2
command -bang -nargs=* LazyGit
    \ call floaterm#run('new', <bang>0, '--width=0.9', '--height=0.6', 'lazygit')

" Utilities {{{1
" StartupTime :: lazy load startuptime.vim plugin {{{2
" command! -nargs=* -complete=file StartupTime call plugins#lazy_run('StartupTime', 'startuptime.vim')
command! -nargs=* -complete=file Startup
    \ call plugins#lazy_run(
    \   'StartupTime',
    \   'vim-startuptime',
    \   {'before': 'silent! delcommand StartupTime'}
    \ )

" Scriptease :: lazy load vim-scriptease plugin {{{2
" command! Messages call plugins#lazy_run('Messages', 'vim-scriptease')
command! -nargs=* -complete=expression PP
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
    \ call qf#scriptnames(<f-args>)
    \| call qf#open(#{size: <count>, stay: v:false})

" WhichKey[Visual] :: display key maps {{{2
" command! -nargs=1 WhichKey
"     \ call plugins#lazy_run(
"     \   'WhichKey',
"     \   'vim-which-key',
"     \   {'args': <q-args>, 'bang': '<bang>'}
"     \ )

" command! -nargs=1 WhichKeyVisual
"     \ call plugins#lazy_run(
"     \   'WhichKeyVisual',
"     \   'vim-which-key',
"     \   {'args': <q-args>, 'bang': '<bang>'}
"     \ )

" Map WhichKey to g:mapleader
execute 'nnoremap <Leader>      <Cmd>WhichKey "'..get(g:, 'mapleader', ',')..'"<CR>'
execute 'nnoremap <LocalLeader> <Cmd>WhichKey "'..get(g:, 'maplocalleader', '\\')..'"<CR>'

" Pretty-printing {{{2
" nvim: Using Lua vim.inspect()
if has('nvim')
    command -complete=expression -nargs=1 LPrint echo v:lua.vim.inspect(<args>)
endif

" Using python pformat (handles lists better but does not convert all vim types
command -complete=expression -nargs=1 PPrint echo util#pformat(<args>)

" Use custom json converter and shell out to `jq` to format
command -complete=expression -nargs=1 JPrint echo util#json_format(<args>)

" nvim-only {{{1
if has('nvim')
    " [H]elp :: floating help window {{{2
    command -complete=help -nargs=? Help lua require'window'.floating_help(<q-args>)
    call map#cabbr('H', 'Help')

    " Colorizer :: run nvim-colorizer.lua {{{2
    " command Colorizer call plugins#lazy_run('ColorizerToggle', 'nvim-colorizer.lua')
    command Colorizer packadd nvim-colorizer.lua | lua require'colorizer'.attach_to_buffer{0, {mode = "foreground"}}

    " LspDisable :: stop active lsp clients {{{2
    command LspDisable lua vim.lsp.stop_client(vim.lsp.get_active_clients())

    " LspLog :: open lsp log {{{2
    command LspLog edit `=v:lua.vim.lsp.get_log_path()`

    " Lua {{{2
    call map#cabbr('l', 'lua')
    call map#cabbr('lp', 'lua p()<Left><C-R>=map#eatchar(''\s'')<CR>')

    " Term :: Run async command in terminal buffer {{{2
    command -complete=file -nargs=+ Term lua require'tools'.term_run_cmd(<f-args>)

    " Sh :: Run async command in shell and output to scratch buffer {{{2
    command -complete=file -nargs=+ Sh lua require'tools'.sh{cmd = <q-args>}

    " Run :: lua version of AsyncRun {{{2
    command -complete=file -bang -nargs=+ Run lua require'tools'.async_run(<q-args>, '<bang>')

    " MRU :: most recently used files {{{2
    command -nargs=? MRU lua require'window'.create_scratch(require'tools'.mru_files(<args>), '<mods>')

    " Redir :: send output of <expr> to scratch window {{{2
    " Usage:
    "   :Redir hi .........show the full output of command ':hi' in a scratch window
    "   :Redir !ls -al ....show the full output of command ':!ls -al' in a scratch window
    command! -bang -nargs=1 -complete=command Redir lua require'tools'.redir{cmd = <q-args>, mods = '<mods>', bang = '<bang>'}

    " Grep :: async grep {{{2
    command! -nargs=+ -complete=file -bar Grep lua require'grep'.grep_for_string(<q-args>)

    " Option :: pretty print option info {{{2
    command -nargs=1 -complete=option Option echo luaeval('vim.inspect(vim.api.nvim_get_option_info(_A[1]))', [<q-args>])

    " Make :: async make {{{2
    " command! -bang -complete=file Make call s:tools.make()

    " Neogit :: lazy load neogit {{{2
    " command! -nargs=* Neogit lua require'config.neogit'.open(require'neogit.lib.util'.parse_command_args(<f-args>))<CR>
endif

" vim:fdl=1:

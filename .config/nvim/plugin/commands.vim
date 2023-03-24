" Scratch :: create scratch window {{{2
command -nargs=* -complete=command Scratch call window#open_scratch(<q-mods>, <q-args>)

" StripWhiteSpace :: remove trailing whitespace {{{2
command StripWhiteSpace call util#preserve('%s/\s\+$//e')

" he[g] :: Open help[grep] in new or existing tab {{{2
call map#cabbr('he', function('window#tab_mod', ['help', 'help']))
call map#cabbr('th', function('window#tab_mod', ['help', 'help']))
call map#cabbr('heg', function('window#tab_mod', ['helpgrep', 'help']))

" pyp :: Python3 print {{{2
call map#cabbr('pyp', 'py3 print()<Left><C-R>=map#eatchar(''\s'')<CR>')

" man :: Open :Man in new or existing tab {{{2
call map#cabbr('man', function('window#tab_mod', ['Man', 'man']))

" [v|h]t :: Open vertical or horizontal split terminal
call map#cabbr('vt', 'vsplit \| terminal')
call map#cabbr('ht', 'split \| terminal')

" fff :: Insert comment with fold marker {{{2
inoreabbrev fff <C-R>=syntax#foldmarker()<CR><C-R>=map#eatchar('\s')<CR>

call map#cabbr('ehco', 'echo')
call map#cabbr('q@', 'q!')

" Misc command abbreviations {{{2
call map#cabbr('grep', 'silent grep!')
call map#cabbr('make', 'silent make!')
call map#cabbr('vh', 'vert help')
call map#cabbr('hg', 'helpgrep')

" Git {{{1
" TigStatus {{{2
call map#cabbr('ts', 'TigStatus')

" LazyGit :: tui for git {{{2
command -bang -nargs=* LazyGit
    \ call floaterm#run('new', <bang>0, '--width=0.9', '--height=0.6', 'lazygit')

" Utilities {{{1
" Redir :: send output of <expr> to scratch window {{{2
" Usage:
"   :Redir hi .........show the full output of command ':hi' in a scratch window
"   :Redir !ls -al ....show the full output of command ':!ls -al' in a scratch window
command! -nargs=1 -complete=command Redir silent call util#redir(<q-args>)

" Scriptnames :: display :scriptnames in quickfix and optionally filter {{{2
command! -nargs=* -bar -count=0 Scriptnames
    \ call qf#scriptnames(<f-args>)
    \| call qf#open(#{size: <count>, stay: v:false})

" Pretty-printing {{{2
" nvim: Using Lua vim.inspect()
command -complete=expression -nargs=1 LPrint echo v:lua.vim.inspect(<args>)

" Using python pformat (handles lists better but does not convert all vim types
command -complete=expression -nargs=1 PPrint echo util#pformat(<args>)

" Use custom json converter and shell out to `jq` to format
command -complete=expression -nargs=1 JPrint echo util#json_format(<args>)

" Lua {{{2
call map#cabbr('l', 'lua')
call map#cabbr('lp', 'lua =<C-R>=map#eatchar(''\s'')<CR>')
call map#cabbr('ld', 'lua d()<Left><C-R>=map#eatchar(''\s'')<CR>')

" vim:fdl=1:

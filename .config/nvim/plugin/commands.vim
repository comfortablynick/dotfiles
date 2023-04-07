" StripWhiteSpace :: remove trailing whitespace {{{2
command StripWhiteSpace call util#preserve('%s/\s\+$//e')

" he[g] :: Open help[grep] in new or existing tab {{{2
call map#cabbr('he', function('window#tab_mod', ['help', 'help']))
call map#cabbr('th', function('window#tab_mod', ['help', 'help']))
call map#cabbr('heg', function('window#tab_mod', ['helpgrep', 'help']))

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

" Utilities {{{1

" Scriptnames :: display :scriptnames in quickfix and optionally filter {{{2
command! -nargs=* -bar -count=0 Scriptnames
    \ call qf#scriptnames(<f-args>)
    \| call qf#open(#{size: <count>, stay: v:false})

" Lua {{{2
call map#cabbr('l', 'lua')
call map#cabbr('lp', 'lua =<C-R>=map#eatchar(''\s'')<CR>')
call map#cabbr('ld', 'lua d()<Left><C-R>=map#eatchar(''\s'')<CR>')

" vim:fdl=1:

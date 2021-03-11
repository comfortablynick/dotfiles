setlocal formatoptions-=cro
setlocal tabstop=2

" setlocal makeprg=yamllint\ -f\ parsable\ %
setlocal makeprg=ansible-lint\ -p\ --nocolor
" setlocal errorformat=%f:%l:\ [E%n]\ %m,'%f:%l:\ [EANSIBLE%n]\ %m,'%f:%l:\ [ANSIBLE%n]\ %m
" let &l:errorformat = '%f:%l: [E%n] %m,'..
"         \ '%f:%l: [EANSIBLE%n] %m,'..
"         \ '%f:%l: [ANSIBLE%n] %m'
let &l:errorformat = '%f:%l: [%t%n] %m,%f:%l: [%tANSIBLE%n] %m'

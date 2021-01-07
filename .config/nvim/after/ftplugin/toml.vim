setlocal tabstop=2
setlocal formatoptions-=cro
setlocal foldmethod=marker

setlocal makeprg=tomlcheck\ -f\ %
setlocal errorformat=%E%f:%l:%c:
setlocal errorformat+=%E%m
setlocal errorformat+=%-G%.%#

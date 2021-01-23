setlocal tabstop=2
setlocal formatoptions-=cro
setlocal foldmethod=marker

" setlocal makeprg=tomlcheck\ -f\ %
" setlocal errorformat=%E%f:%l:%c:
" setlocal errorformat+=%E%m
" setlocal errorformat+=%-G%.%#
setlocal makeprg=taplo\ lint\ %
" setlocal errorformat=%C\ %#-->\ %f:%l:%c
setlocal errorformat=
            \%-G,
            \%-Gerror:\ aborting\ %.%#,
            \%-Gerror:\ Could\ not\ compile\ %.%#,
            \%Eerror:\ %m,
            \%Eerror[E%n]:\ %m,
            \%Wwarning:\ %m,
            \%Inote:\ %m,
            \%C\ %#-->\ %f:%l:%c,
            \%E\ \ left:%m,%C\ right:%m\ %f:%l:%c,%Z

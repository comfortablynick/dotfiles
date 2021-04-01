setlocal formatoptions-=cro
setlocal tabstop=2
setlocal foldlevel=2

if &filetype =~# 'ansible'
    setlocal makeprg=ansible-lint\ -qqp\ --nocolor\ %
    setlocal errorformat=%f:%l:\ %m
else
    setlocal makeprg=yamllint\ -f\ parsable\ %
    setlocal errorformat=%f:%l:%c:\ [%t%*[^\ ]]\ %m
endif

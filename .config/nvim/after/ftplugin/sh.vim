setlocal foldmethod=marker
setlocal formatoptions-=cro

" Use shfmt
let &l:formatprg = 'shfmt -i '.shiftwidth()

setlocal foldmethod=marker

" Use shfmt
let &l:formatprg = 'shfmt -i '.shiftwidth()

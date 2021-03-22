let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_autopreview = 0
let g:tagbar_sort = 0
let g:tagbar_silent = 1

" Filetypes
let g:tagbar_type_typescript = {
    \ 'ctagstype': 'typescript',
    \ 'kinds': [
    \   'c:classes',
    \   'n:modules',
    \   'f:functions',
    \   'v:variables',
    \   'v:varlambdas',
    \   'm:members',
    \   'i:interfaces',
    \   'e:enums',
    \   ]
    \ }

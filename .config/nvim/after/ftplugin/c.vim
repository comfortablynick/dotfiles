setlocal formatoptions-=cro
setlocal commentstring=//\ %s
setlocal makeprg=gcc\ -Wall\ -o\ %<\ %

let g:compiler_gcc_ignore_unmatched_lines = 1

" Disable function highlighting (affects both C and C++ files)
let g:cpp_no_function_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group `Statement`
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

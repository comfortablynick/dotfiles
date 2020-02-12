if exists('g:loaded_ftplugin_cpp_gur8ndia') | finish | endif
let g:loaded_ftplugin_cpp_gur8ndia = 1

let b:load_doxygen_syntax = 1
let g:quickfix_open = 24

" Disable function highlighting (affects both C and C++ files)
let g:cpp_no_function_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group `Statement`
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

" Enable highlighting of named requirements (C++20 library concepts)
let g:cpp_named_requirements_highlight = 1

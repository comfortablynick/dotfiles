if exists('g:loaded_ftplugin_c_tlw3rcnn') | finish | endif
let g:loaded_ftplugin_c_tlw3rcnn = 1

" Disable function highlighting (affects both C and C++ files)
let g:cpp_no_function_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group `Statement`
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

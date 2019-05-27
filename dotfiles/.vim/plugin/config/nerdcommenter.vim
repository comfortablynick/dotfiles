if exists('g:loaded_nerdcommenter_config')
    finish
endif
let g:loaded_nerdcommenter_config = 1

let g:NERDSpaceDelims = 1                       " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1                   " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'                 " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1                    " Set a language to use its alternate delimiters by default
let g:NERDCommentEmptyLines = 1                 " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1            " Enable trimming of trailing whitespace when uncommenting
let g:NERDToggleCheckAllLines = 1               " Enable NERDCommenterToggle to check all selected lines is commented or not

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = {
 \ 'c':
 \   { 'left': '/**', 'right': '*/' },
 \ 'json':
 \   { 'left': '//' },
 \ }

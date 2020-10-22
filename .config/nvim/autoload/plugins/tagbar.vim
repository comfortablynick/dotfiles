function! plugins#tagbar#pre() abort
    let g:tagbar_autoclose = 1                                      " Autoclose tagbar after selecting tag
    let g:tagbar_autofocus = 1                                      " Move focus to tagbar when opened
    let g:tagbar_compact = 1                                        " Eliminate help msg, blank lines
    let g:tagbar_autopreview = 0                                    " Open preview window with selected tag details
    let g:tagbar_sort = 0                                           " Sort tags alphabetically vs. in file order
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
endfunction

function! plugins#tagbar#toggle() abort
    silent! packadd tagbar
    TagbarToggle
endfunction

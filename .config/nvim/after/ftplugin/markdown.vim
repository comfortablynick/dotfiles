function! s:indent(indent)
    if getline('.') =~# '\v^\s*%([-*+]|\d\.)\s*$'
        " Empty list
        if a:indent
            normal! >>
        else
            normal! <<
        endif
        call setline('.', substitute(getline('.'), '\([-*+]\|\d\.\)\s*$', '\1 ', ''))
        normal! $
    elseif getline('.') =~# '\v^\s*(\s?\>)+\s*$'
        " Empty quote
        if a:indent
            call setline('.', substitute(getline('.'), '>\s*$', '>> ', ''))
        else
            call setline('.', substitute(getline('.'), '\s*>\s*$', ' ', ''))
            call setline('.', substitute(getline('.'), '^\s\+$', '', ''))
        endif
        normal! $
    endif
endfunction

inoremap <buffer> <script> <expr> <C-]>
    \ '<C-O>:call <SID>indent(1)<CR>'
inoremap <buffer> <script> <expr> <C-[>
    \ '<C-O>:call <SID>indent(0)<CR>'

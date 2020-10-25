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

function! s:jump_to_heading(direction, count)
    let l:col = col('.')
    silent execute a:direction ==# 'up' ? '?^#' : '/^#'
    if a:count > 1
        silent execute 'normal!' repeat('n', a:direction ==# 'up' && l:col != 1 ? a:count : a:count - 1)
    endif
    silent execute 'normal!' l:col '|'
    unlet l:col
endfunction

nnoremap <buffer> <silent> ]] :<C-u>call <SID>jump_to_heading("down", v:count1)<CR>
nnoremap <buffer> <silent> [[ :<C-u>call <SID>jump_to_heading("up", v:count1)<CR>

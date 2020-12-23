setlocal tabstop=2
setlocal spell

" function! MarkdownFoldLevel()
"     " WIP: only increases fold level, never decreases
"     let l:currline = getline(v:lnum)
"     if l:currline =~# '^## .*$'     | return '>1' | endif
"     if l:currline =~# '^### .*$'    | return '>2' | endif
"     if l:currline =~# '^#### .*$'   | return '>3' | endif
"     if l:currline =~# '^##### .*$'  | return '>4' | endif
"     if l:currline =~# '^###### .*$' | return '>5' | endif
"     return '='
" endfunction
"
" setlocal foldexpr=MarkdownFoldLevel()
" setlocal foldmethod=expr
" setlocal foldlevel=1

function s:indent(indent)
    let l:col = virtcol('.')
    if a:indent
        execute 'normal! >>' (l:col + shiftwidth())..'|'
    else
        execute 'normal! <<' (l:col - shiftwidth())..'|'
    endif
endfunction

function s:is_empty_list_item()
    return getline('.') =~# '\v^\s*%([-*+]|\d\.)\s*$'
endfunction

function s:is_empty_quote()
    return getline('.') =~# '\v^\s*(\s?\>)+\s*$'
endfunction

inoremap <buffer> <C-]> <Cmd>call <SID>indent(1)<CR>
inoremap <buffer> <C-[> <Cmd>call <SID>indent(0)<CR>

function s:jump_to_heading(direction, count)
    let l:col = virtcol('.')
    execute a:direction ==# 'up' ? '?^#' : '/^#'
    if a:count > 1
        execute 'normal!' repeat('n', a:direction ==# 'up' && l:col != 1 ? a:count : a:count - 1)
    endif
    execute 'normal!' l:col..'|'
endfunction

nnoremap <buffer> ]] <Cmd>call <SID>jump_to_heading("down", v:count1)<CR>
nnoremap <buffer> [[ <Cmd>call <SID>jump_to_heading("up", v:count1)<CR>

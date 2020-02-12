if exists('g:loaded_after_ftplugin_markdown') | finish | endif
let g:loaded_after_ftplugin_markdown = 1

function! s:indent(indent)
    if s:is_empty_list_item()
        if a:indent
            normal! >>
        else
            normal! <<
        endif
        call setline('.', substitute(getline('.'), '\([-*+]\|\d\.\)\s*$', '\1 ', ''))
        normal! $
    elseif s:is_empty_quote()
        if a:indent
            call setline('.', substitute(getline('.'), '>\s*$', '>> ', ''))
        else
            call setline('.', substitute(getline('.'), '\s*>\s*$', ' ', ''))
            call setline('.', substitute(getline('.'), '^\s\+$', '', ''))
        endif
        normal! $
    endif
endfunction

function! s:is_empty_list_item() abort
    return getline('.') =~# '\v^\s*%([-*+]|\d\.)\s*$'
endfunction

function! s:is_empty_quote() abort
    return getline('.') =~# '\v^\s*(\s?\>)+\s*$'
endfunction

if !exists(':MarkdownEditBlock')
    " Dont' use if vim-markdown is installed
    inoremap <silent> <buffer> <script> <expr> <Tab>
        \ <SID>is_empty_list_item() \|\| <SID>is_empty_quote() ? '<C-O>:call <SID>indent(1)<CR>' : '<Tab>'
    inoremap <silent> <buffer> <script> <expr> <S-Tab>
        \ <SID>is_empty_list_item() \|\| <SID>is_empty_quote() ? '<C-O>:call <SID>indent(0)<CR>' : '<Tab>'
endif

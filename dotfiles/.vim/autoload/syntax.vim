" ====================================================
" Filename:    autoload/syntax.vim
" Description: Syntax related functions
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-31 09:21:39 CST
" ====================================================

" Enable embedded syntax
function! syntax#enable_code_snip(filetype,start,end,textSnipHl) abort
    let ft=toupper(a:filetype)
    let group='textGroup'.ft
    if exists('b:current_syntax')
        let s:current_syntax=b:current_syntax
        " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
        " do nothing if b:current_syntax is defined.
        unlet b:current_syntax
    endif
    execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
    try
        execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
    catch
    endtry
    if exists('s:current_syntax')
        let b:current_syntax=s:current_syntax
    else
        unlet b:current_syntax
    endif
    execute 'syntax region textSnip'.ft.'
        \ matchgroup='.a:textSnipHl.'
        \ keepend
        \ start="'.a:start.'" end="'.a:end.'"
        \ contains=@'.group
endfunction

" Use syntax stack to find if cursor is in comment
function! syntax#is_comment() abort
    let hg = join(syntax#synstack())
    return hg =~? 'comment\|string\|character\|doxygen' ? 1 : 0
endfunction

function! syntax#is_comment_line() abort
    let hg = join(map(synstack(line('.'), col('$')-1), {_,v -> synIDattr(v, "name")}))
    return hg =~? 'comment\|string\|character\|doxygen' ? 1 : 0
endfunction

" Get syntax group of item under cursor
function! syntax#syngroup() abort
    let l:s = synID(line('.'), col('.'), 1)
    let l:name = synIDattr(l:s, 'name')
    let l:linked =  synIDattr(synIDtrans(l:s), 'name')
    return l:name !=# l:linked ? l:name.' -> '.l:linked : l:name
endfunction

" Get syntax stack of item under cursor
function! syntax#synstack() abort
    return map(synstack(line('.'), col('.')), {_,v -> synIDattr(v, "name")})
endfunction

" Return details of syntax highlight
function! syntax#extract_highlight(group, what, ...) abort
    if a:0 == 1
        return synIDattr(synIDtrans(hlID(a:group)), a:what, a:1)
    else
        return synIDattr(synIDtrans(hlID(a:group)), a:what)
    endif
endfunction

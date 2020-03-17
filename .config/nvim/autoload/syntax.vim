" ====================================================
" Filename:    autoload/syntax.vim
" Description: Syntax related functions
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-03-16 15:26:45 CDT
" ====================================================

" Enable embedded syntax
function! syntax#enable_code_snip(filetype,start,end,textSnipHl) abort
    let l:ft=toupper(a:filetype)
    let l:group='textGroup'.l:ft
    if exists('b:current_syntax')
        let s:current_syntax=b:current_syntax
        " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
        " do nothing if b:current_syntax is defined.
        unlet b:current_syntax
    endif
    execute 'syntax include @'.l:group.' syntax/'.a:filetype.'.vim'
    try
        execute 'syntax include @'.l:group.' after/syntax/'.a:filetype.'.vim'
    catch
    endtry
    if exists('s:current_syntax')
        let b:current_syntax=s:current_syntax
    else
        unlet b:current_syntax
    endif
    execute 'syntax region textSnip'.l:ft.'
        \ matchgroup='.a:textSnipHl.'
        \ keepend
        \ start="'.a:start.'" end="'.a:end.'"
        \ contains=@'.l:group
endfunction

" Use syntax stack to find if cursor is in comment
function! syntax#is_comment() abort
    let l:hg = join(syntax#synstack())
    return l:hg =~? 'comment\|string\|character\|doxygen' ? 1 : 0
endfunction

function! syntax#is_comment_line() abort
    let l:hg = join(map(synstack(line('.'), col('$')-1), {_,v -> synIDattr(v, 'name')}))
    return l:hg =~? 'comment\|string\|character\|doxygen' ? 1 : 0
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
    return map(synstack(line('.'), col('.')), {_,v -> synIDattr(v, 'name')})
endfunction

" Return details of syntax highlight
function! syntax#extract_highlight(group, what, ...) abort
    if a:0 == 1
        return synIDattr(synIDtrans(hlID(a:group)), a:what, a:1)
    else
        return synIDattr(synIDtrans(hlID(a:group)), a:what)
    endif
endfunction

function! syntax#get_color(attr, ...) abort
    let l:gui = has('termguicolors') && &termguicolors
    let l:fam = l:gui ? 'gui' : 'cterm'
    let l:pat = l:gui ? '^#[a-f0-9]\+' : '^[0-9]\+$'
    for l:group in a:000
        let l:code = synIDattr(synIDtrans(hlID(l:group)), a:attr, l:fam)
        if l:code =~? l:pat
            return l:code
        endif
    endfor
    return ''
endfunction

" Borrowed from fzf.vim
let s:ansi = {'black': 30, 'red': 31, 'green': 32, 'yellow': 33, 'blue': 34, 'magenta': 35, 'cyan': 36, 'white': 0}

function! s:csi(color, fg) abort
    let l:prefix = a:fg ? '38;' : '48;'
    if a:color[0] == '#'
        return l:prefix.'2;'.join(map([a:color[1:2], a:color[3:4], a:color[5:6]], 'str2nr(v:val, 16)'), ';')
    endif
    return l:prefix.'5;'.a:color
endfunction

function! syntax#ansi(str, group, ...) abort
    let l:fg = syntax#get_color('fg', a:group)
    let l:bg = syntax#get_color('bg', a:group)
    let l:default = get(a:, 1, 'white')
    let l:bold = get(a:, 1, 0)
    let l:color = (empty(l:fg) ? s:ansi[l:default] : s:csi(l:fg, 1)) .
        \ (empty(l:bg) ? '' : ';'.s:csi(l:bg, 0))
    return printf("\x1b[%s%sm%s\x1b[m", l:color, l:bold ? ';1' : '', a:str)
endfunction

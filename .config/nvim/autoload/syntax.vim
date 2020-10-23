" Enable embedded syntax
function syntax#enable_code_snip(filetype,start,end,textSnipHl)
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
function syntax#is_comment()
    let l:hg = join(syntax#synstack())
    return l:hg =~? 'comment\|string\|character\|doxygen' ? 1 : 0
endfunction

function syntax#is_comment_line()
    let l:hg = join(map(synstack(line('.'), col('$')-1), {_,v -> synIDattr(v, 'name')}))
    return l:hg =~? 'comment\|string\|character\|doxygen' ? 1 : 0
endfunction

" Get syntax group of item under cursor
function syntax#syngroup()
    let l:s = synID(line('.'), col('.'), 1)
    let l:name = synIDattr(l:s, 'name')
    let l:linked =  synIDattr(synIDtrans(l:s), 'name')
    return l:name !=# l:linked ? l:name.' -> '.l:linked : l:name
endfunction

" Get syntax stack of item under cursor
function syntax#synstack()
    return map(synstack(line('.'), col('.')), {_,v -> synIDattr(v, 'name')})
endfunction

" Return details of syntax highlight
function syntax#extract_highlight(group, what, ...)
    if a:0 == 1
        return synIDattr(synIDtrans(hlID(a:group)), a:what, a:1)
    else
        return synIDattr(synIDtrans(hlID(a:group)), a:what)
    endif
endfunction

function syntax#get_color(attr, ...)
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

" Derive a  new syntax group  (`to`) from  an existing one  (`from`), overriding
" some attributes (if supplied as optional arguments)
" Example: call syntax#derive('Statusline', 'StatuslineNC', 'guibg=red', 'guifg=black')
function syntax#derive(from, to, ...)
    " Why `filter(split(...))`? {{{
    "
    " The output of `:hi ExistingHG`  can contain noise in certain circumstances
    " (e.g. `-V15/tmp/log`, `-D`, `$ sudo`...).
    " }}}
    let l:new_attributes = a:0 > 0 ? a:000 : ['']
    let l:old_attributes = join(map(copy(l:new_attributes), {_,v -> substitute(v, '=\S*', '', '')}), '\|')
    let l:original_definition = filter(split(execute('hi '..a:from), '\n'), {_,v -> v =~# '^'..a:from })[0]
    " the `from` syntax group is linked to another group
    if l:original_definition =~# ' links to \S\+$'
        " Why the `while` loop? {{{
        "
        " Well, we don't know how many links there are; there may be more than one.
        " That is, the  `from` syntax group could be linked  to `A`, which could
        " be linked to `B`, ...
        " }}}
        let l:g = 0
        while l:original_definition =~# ' links to \S\+$' && l:g < 9
            let l:g += 1
            let l:link = matchstr(l:original_definition, ' links to \zs\S\+$')
            let l:original_definition = filter(split(execute('hi '..l:link), '\n'), {_,v -> v =~# '^'..l:link })[0]
            let l:original_group = l:link
        endwhile
    else
        let l:original_group = a:from
    endif
    let l:pat = '^'..l:original_group..'\|xxx\|\<\%('..l:old_attributes..'\)=\S*'
    let l:Rep = {m -> m[0] is# l:original_group ? a:to : ''}
    execute 'hi'
        \ substitute(l:original_definition, l:pat, l:Rep, 'g')
        \ join(l:new_attributes)
endfunction

" Borrowed from fzf.vim
let s:ansi = {'black': 30, 'red': 31, 'green': 32, 'yellow': 33, 'blue': 34, 'magenta': 35, 'cyan': 36, 'white': 0}

function s:csi(color, fg)
    let l:prefix = a:fg ? '38;' : '48;'
    if a:color[0] == '#'
        return l:prefix.'2;'.join(map([a:color[1:2], a:color[3:4], a:color[5:6]], 'str2nr(v:val, 16)'), ';')
    endif
    return l:prefix.'5;'.a:color
endfunction

function syntax#ansi(str, group, ...)
    let l:fg = syntax#get_color('fg', a:group)
    let l:bg = syntax#get_color('bg', a:group)
    let l:default = get(a:, 1, 'white')
    let l:bold = get(a:, 1, 0)
    let l:color = (empty(l:fg) ? s:ansi[l:default] : s:csi(l:fg, 1)) .
        \ (empty(l:bg) ? '' : ';'.s:csi(l:bg, 0))
    return printf("\x1b[%s%sm%s\x1b[m", l:color, l:bold ? ';1' : '', a:str)
endfunction

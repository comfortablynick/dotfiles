" Prettyprint vim variables
" Version: 0.3.4
" Original Author: thinca <thinca+vim@gmail.com>
" Modified By: Nick Murphy <comfortablynick@gmail.com>
" License: zlib License

" Options {{{1
let g:prettyprint_indent          = get(g:, 'prettyprint_indent', 2)
let g:prettyprint_width           = get(g:, 'prettyprint_width', min([79, winwidth(0)]))
let g:prettyprint_string          = get(g:, 'prettyprint_string', [])
let g:prettyprint_show_expression = get(g:, 'prettyprint_show_expression', 0)

" Functions {{{1
function s:pp(expr, shift, width, stack) "{{{2
    let l:indent = repeat(s:blank, a:shift)
    let l:indentn = l:indent..s:blank

    let l:appear = index(a:stack, a:expr)
    call add(a:stack, a:expr)

    let l:width = s:width - a:width - s:indent * a:shift

    let l:str = ''
    if type(a:expr) ==# v:t_list
        if l:appear < 0
            let l:result = []
            for l:Expr in a:expr
                call add(l:result, s:pp(l:Expr, a:shift + 1, 0, a:stack))
                unlet l:Expr
            endfor
            let l:oneline = '['..join(l:result, ', ')..']'
            if strlen(l:oneline) < l:width && l:oneline !~# "\n"
                let l:str = l:oneline
            else
                let l:content = join(map(l:result, {_,v -> l:indentn..v}), ",\n")
                let l:str = printf("[\n%s\n%s]", l:content, l:indent)
            endif
        else
            let l:str = '[nested element '..l:appear .']'
        endif

    elseif type(a:expr) ==# v:t_dict
        if l:appear < 0
            let l:result = []
            for l:key in sort(keys(a:expr))
                let l:skey = string(strtrans(l:key))
                let l:sep = ': '
                let l:Val = get(a:expr, l:key)  " Do not use a:expr[key] to avoid Partial
                let l:valstr = s:pp(l:Val, a:shift + 1, strlen(l:skey..l:sep), a:stack)
                if s:indent < strlen(l:skey..l:sep) &&
                    \ l:width - s:indent < strlen(l:skey..l:sep..l:valstr) && l:valstr !~# "\n"
                    let l:sep = ":\n"..l:indentn..s:blank
                endif
                call add(l:result, l:skey..l:sep..l:valstr)
                unlet l:Val
            endfor
            let l:oneline = '{'..join(l:result, ', ')..'}'
            if strlen(l:oneline) < l:width && l:oneline !~# "\n"
                let l:str = l:oneline
            else
                let l:content = join(map(l:result, {_,v -> l:indentn..v}), ",\n")
                let l:str = printf("{\n%s\n%s}", l:content, l:indent)
            endif
        else
            let l:str = '{nested element '..l:appear..'}'
        endif

    elseif type(a:expr) ==# v:t_func
        silent! let l:funcstr = string(a:expr)
        let l:matched = matchlist(l:funcstr, '\C^function(''\(.\{-}\)''\()\?\)')
        let l:funcname = l:matched[1]
        let l:is_partial = l:matched[2] !=# ')'
        let l:symbol = l:funcname =~# '^\%(<lambda>\)\?\d\+$' ?
            \                         '{"'..l:funcname..'"}' : l:funcname
        if &verbose && exists('*'..l:symbol)
            let l:str = execute((&verbose - 1)..'verbose function '..l:symbol)
        elseif l:is_partial
            let l:str = printf("function('%s', {partial})", l:funcname)
        else
            let l:str = printf("function('%s')", l:funcname)
        endif
    elseif type(a:expr) ==# v:t_string
        let l:str = a:expr
        if a:expr =~# "\n" && s:string_split
            let l:expr = s:string_raw ? 'string(v:val)' : 'string(strtrans(v:val))'
            let l:str = "join([\n"..l:indentn .
                \ join(map(split(a:expr, '\n', 1), l:expr), ",\n"..l:indentn) .
                \ "\n"..l:indent..'], "\n")'
        elseif s:string_raw
            let l:str = string(a:expr)
        else
            let l:str = string(strtrans(a:expr))
        endif
    else
        let l:str = string(a:expr)
    endif

    unlet a:stack[-1]
    return l:str
endfunction

function s:option(name) "{{{2
    let l:name = 'prettyprint_'..a:name
    let l:opt = has_key(b:, l:name) ? b:[l:name] : g:[l:name]
    return type(l:opt) ==# v:t_string ? eval(l:opt) : l:opt
endfunction

function prettyprint#echo(str, msg, expr) "{{{2
    let l:str = a:str
    if g:prettyprint_show_expression
        let l:str = a:expr..' = '..l:str
    endif
    if a:msg
        for l:s in split(l:str, "\n")
            echomsg l:s
        endfor
    else
        echo l:str
    endif
endfunction

function prettyprint#prettyprint(...) "{{{2
    let s:indent = s:option('indent')
    let s:blank = repeat(' ', s:indent)
    let s:width = s:option('width') - 1
    let l:string = s:option('string')
    let l:strlist = type(l:string) ==# v:t_list ? l:string : [l:string]
    let s:string_split = 0 <= index(l:strlist, 'split')
    let s:string_raw = 0 <= index(l:strlist, 'raw')
    let l:result = []
    for l:Expr in a:000
        call add(l:result, s:pp(l:Expr, 0, 0, []))
        unlet l:Expr
    endfor
    return join(l:result, "\n")
endfunction

" vim:fdl=1:

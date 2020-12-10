" util#capture() :: Capture output of command and return as list {{{1
function util#capture(cmd)
    if a:cmd =~# '^!'
        " System command output
        let l:cmd = a:cmd =~# ' %' ? substitute(a:cmd, ' %', ' ' . expand('%:p'), '') : a:cmd
        return systemlist(matchstr(l:cmd, '^!\zs.*'))
    endif
    " Redirect of vim command
    let l:out = execute(a:cmd)
    return split(l:out, '\n')
endfunction

" util#redir() :: Redirect output of command to scratch buffer {{{1
" Borrowed some from romainl:
" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function util#redir(cmd)
    for l:win in range(1, winnr('$'))
        if getwinvar(l:win, 'scratch')
            execute l:win 'windo close'
        endif
    endfor
    if type(a:cmd) == v:t_list
        let l:lines = a:cmd
    else
        let l:lines = util#capture(a:cmd)
    endif
    vnew
    let w:scratch = 1
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile foldlevel=99
    call setline(1, l:lines)
endfunction

" util#scriptnames() :: Convert :scriptnames into qf format {{{1
function util#scriptnames()
    return map(
        \ map(util#capture('scriptnames'), { _, v -> split(v, "\\v:=\\s+")}),
        \ {_, v -> {'text': v[0], 'filename': expand(v[1])}}
        \ )
endfunction

" util#pformat() :: Pretty format using python3 pprint {{{1
function util#pformat(args)
py3 <<END
import vim
from pprint import pformat
args = pformat(vim.eval('a:args'))
END
    return py3eval('args')
endfunction

" util#json_encode() :: Encode data structure into json {{{1
" Originally from:
" https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/autoload/tj.vim
function util#json_encode(val)
    if type(a:val) == v:t_number
        return a:val
    elseif type(a:val) == v:t_string
        let l:json = '"'..escape(a:val, '\"')..'"'
        let l:json = substitute(l:json, "\r", '\\r', 'g')
        let l:json = substitute(l:json, "\n", '\\n', 'g')
        let l:json = substitute(l:json, "\t", '\\t', 'g')
        let l:json = substitute(l:json, '\([[:cntrl:]]\)', '\=printf("\x%02d", char2nr(submatch(1)))', 'g')
        return iconv(l:json, &encoding, 'utf-8')
    elseif type(a:val) == v:t_func
        let l:s = substitute(string(a:val), 'function(', '', '')[:-2]
        let l:args_split = split(l:s, ', ')

        if len(l:args_split) <= 1
            return util#json_encode(substitute(l:args_split[0], "'", '', 'g'))
        endif
        return util#json_encode('function('..l:args_split[0]..')')
    elseif type(a:val) == 3
        return '['..join(map(copy(a:val), {_,v->util#json_encode(v)}), ',')..']'
    elseif type(a:val) == v:t_dict
        return '{'..join(map(keys(a:val),
            \ {_,v->util#json_encode(v)..':'..util#json_encode(a:val[v])}), ',')..'}'
    elseif type(a:val) == v:t_bool
        return a:val ? 'true' : 'false'
    endif
endfunction

" util#json_format() :: Format json using jq {{{1
function util#json_format(val)
    let l:json = util#json_encode(a:val)
    return system('echo '..shellescape(l:json)..' | jq -S .')
endfunction

" util#jdump() :: Dump object as json with configurable format {{{1
" Adapted from github.com/tpope/vim-jdaddy
function s:sub(str,pat,rep)
  return substitute(a:str,'\v\C'.a:pat,a:rep,'')
endfunction

function s:gsub(str,pat,rep)
  return substitute(a:str,'\v\C'.a:pat,a:rep,'g')
endfunction

let s:escapes = {
    \ "\b": '\b',
    \ "\f": '\f',
    \ "\n": '\n',
    \ "\r": '\r',
    \ "\t": '\t',
    \ "\"": '\"',
    \ "\\": '\\',
    \ }

" TODO: implement this logic in lua to speed it up
function util#jdump(object, ...)
    let l:opt = extend(#{width: 79, level: 0, indent: 2, before: 0, seen: []}, a:0 ? copy(a:1) : {})
    let l:opt.seen = copy(l:opt.seen)
    let l:childopt = copy(l:opt)
    let l:childopt.before = 0
    let l:childopt.level += 1
    let l:indent = repeat(' ', l:opt.indent)
    for l:i in range(len(l:opt.seen))
        if a:object is# l:opt.seen[l:i]
            return type(a:object) is# v:t_list ? '[...]' : '{...}'
        endif
    endfor
    if a:object is# v:null
        return 'null'
    elseif a:object is# v:false
        return 'false'
    elseif a:object is# v:true
        return 'true'
    elseif type(a:object) is# v:t_string
        if a:object =~# '^\%x02.'
            let l:dump = a:object[1:-1]
        else
            let l:dump = '"'..s:gsub(a:object, "[\001-\037\"\\\\]", '\=get(s:escapes, submatch(0), printf("\\u%04x", char2nr(submatch(0))))')..'"'
        endif
    elseif type(a:object) is# v:t_list
        let l:childopt.seen += [a:object]
        let l:dump = '['.join(map(copy(a:object), {_,v->util#jdump(v, #{seen: l:childopt.seen, level: l:childopt.level})}), ', ').']'
        if l:opt.width && l:opt.before + l:opt.level * l:opt.indent + len(s:gsub(l:dump, '.', '.')) > l:opt.width
            let l:space = repeat(l:indent, l:opt.level)
            let l:dump = '['..join(map(copy(a:object), {_,v->"\n"..l:indent..l:space..util#jdump(v, l:childopt)}), ',').."\n"..l:space..']'
        endif
    elseif type(a:object) is# v:t_dict
        let l:childopt.seen += [a:object]
        let l:keys = sort(keys(a:object))
        let l:dump = '{'..join(map(copy(l:keys), {_,v->util#jdump(v)..': '..util#jdump(a:object[v], #{seen: l:childopt.seen, indent: l:childopt.indent, level: l:childopt.level})}), ', ')..'}'
        if l:opt.width && l:opt.before + l:opt.level * l:opt.indent + len(s:gsub(l:dump, '.', '.')) > l:opt.width
            let l:space = repeat(l:indent, l:opt.level)
            let l:lines = []
            let l:last = get(l:keys, -1, '')
            for l:k in l:keys
                let l:prefix = util#jdump(l:k)..':'
                let l:suffix = util#jdump(a:object[l:k])..','
                if len(l:space..l:prefix..' '..l:suffix) >= l:opt.width - (l:k ==# l:last ? -1 : 0)
                    call extend(l:lines, [l:prefix..' '..util#jdump(a:object[l:k], extend(copy(l:childopt), {'before': len(l:prefix)+1}))..','])
                else
                    call extend(l:lines, [l:prefix..' '..l:suffix])
                endif
            endfor
            let l:dump = s:sub("{\n"..l:indent..l:space.. join(l:lines, "\n"..l:indent..l:space), ',$', "\n"..l:space..'}')
        endif
    else
        let l:dump = string(a:object)
    endif
    return l:dump
endfunction

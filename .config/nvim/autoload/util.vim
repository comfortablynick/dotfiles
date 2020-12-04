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

function util#json_format(val)
    let l:json = util#json_encode(a:val)
    return system('echo '..shellescape(l:json)..' | jq -S .')
endfunction

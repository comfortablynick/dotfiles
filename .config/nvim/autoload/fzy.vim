let s:guard = 'g:loaded_autoload_fzy' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" fzy#command() :: Pipe command into fzy and execute vim command with choice
function! fzy#command(choice_command, vim_command)
    let l:file = tempname()
    let l:winid = win_getid()
    let l:cmd = split(&shell) + split(&shellcmdflag) + [a:choice_command . ' | fzy > ' . l:file]
    let l:F = function('s:completed', [l:winid, l:file, a:vim_command])
    botright 10 new
    if has('nvim')
        call termopen(l:cmd, {'on_exit': l:F})
    else
        call term_start(l:cmd, {'exit_cb': l:F, 'curwin': 1})
    endif
    startinsert
endfunction

function! s:completed(winid, filename, action, ...) abort
    bdelete!
    call win_gotoid(a:winid)
    if filereadable(a:filename)
        let l:lines = readfile(a:filename)
        if !empty(l:lines)
            execute a:action l:lines[0]
        endif
        call delete(a:filename)
    endif
endfunction

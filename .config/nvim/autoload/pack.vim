" function pack#lazy_run() :: Lazy-load a package on a command or funcref {{{2
" Inspired by:
" https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/autoload/util.vim
" Optional options dict:
" `start` Range start
" `end` Range end
" `bang` <bang> from command
" `args` <q-args> from command
function pack#lazy_run(cmd, package, ...)
    if !pack#exists(a:package)
        echohl WarningMsg
        echo 'Package' a:package 'not found in packpath!'
        echohl None
        return
    endif
    let l:packages   = type(a:package) isnot v:t_list ? [a:package] : a:package
    let l:args       = get(a:, 1, {})
    let l:before     = get(l:args, 'before', [])
    let l:after      = get(l:args, 'after', [])
    let l:start      = get(l:args, 'start', 0)
    let l:end        = get(l:args, 'end',   0)
    let l:bang       = get(l:args, 'bang',  '')
    let l:extra_args = get(l:args, 'args',  '')
    " Exec before command(s)
    if type(l:before) isnot v:t_list
        let l:before = [l:before]
    endif
    for l:before_cmd in l:before
        execute l:before_cmd
    endfor

    " Source packages
    for l:package in l:packages
        execute 'packadd' l:package
    endfor

    " Exec after command(s)
    if type(l:after) isnot v:t_list
        let l:after = [l:after]
    endif
    for l:after_cmd in l:after
        execute l:after_cmd
    endfor
    if type(a:cmd) is v:t_func
        return a:cmd()
    endif
    if type(l:bang) is v:t_number
        let l:bang = l:bang ==# 1 ? '!' : ''
    endif

    if type(l:extra_args) is v:t_list
        let l:extra_args = join(l:extra_args, ' ')
    endif
    " Build command
    let l:final_cmd = printf(
        \ '%s%s%s %s',
        \ (l:start == l:end ? '' : (l:start . ',' . l:end)),
        \ a:cmd,
        \ l:bang,
        \ l:extra_args
        \ )
    if get(l:args, 'debug', 0)
        " Debug print
        echo l:final_cmd
        return
    endif
    execute l:final_cmd
endfunction

" function pack#exists() :: check if plugin exists in &packpath {{{2
" `plugin` Plugin name or glob pattern
function pack#exists(plugin)
    return !empty(globpath(&packpath, 'pack/*/*/'.a:plugin))
endfunction
" vim:fdl=1:

" ====================================================
" Filename:    autoload/config/minpac.vim
" Description: Custom minpac functions
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-11-24
" ====================================================

function! config#minpac#add(repo, ...) abort
    let l:opts = extend(copy(get(a:000, 0, {})),
        \ { 'type': 'opt'}, 'keep')
    if has_key(l:opts, 'for')
        let l:name = substitute(a:repo, '^.*/', '', '')
        let l:ft = type(l:opts.for) == type([]) ? join(l:opts.for, ',') : l:opts.for
        execut printf('autocmd FileType %s packadd %s', l:ft, l:name)
    else
        " Add defaults
        call minpac#add(a:repo, l:opts)
    end
endfunction

function! config#minpac#update_all() abort
    " Load remote plugins
    let g:deoplete#enable_at_startup = 0
    packadd! deoplete.nvim
    call minpac#update('', {'do': 'call minpac#status()'})
endfunction

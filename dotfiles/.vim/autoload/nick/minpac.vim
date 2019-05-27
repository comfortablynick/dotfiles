if exists('g:loaded_minpac_vim_funcs')
    finish
endif
let g:loaded_minpac_vim_funcs = 1

" TODO: add FileType autocmd function

function! nick#minpac#add(repo, ...) abort
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


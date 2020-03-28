let s:guard = 'g:loaded_autoload_plugins_miniyank' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#miniyank#post() abort
    let g:miniyank_maxitems = 50

    " Replace built-in put with autoput
    map p <Plug>(miniyank-autoput)
    map P <Plug>(miniyank-autoPut)

    " Put most recent item in shared history
    map <Leader>p <Plug>(miniyank-startput)
    map <Leader>P <Plug>(miniyank-startPut)

    map <Leader>y <Plug>(miniyank-cycle)
    map <Leader>Y <Plug>(miniyank-cycleback)
    map <Leader>Y <Plug>(miniyank-cycleback)
endfunction

" Adapted from https://github.com/bfredl/nvim-miniyank/issues/19#issue-347454437
function! s:fzf_miniyank(put_before, fullscreen) abort
    function! Sink(opt, line) abort
        let l:key = substitute(a:line, ' .*', '', '')
        if empty(a:line) | return | endif
        let l:yanks = miniyank#read()[l:key]
        call miniyank#drop(l:yanks, a:opt)
    endfunction

    let l:put_action = a:put_before ? 'P' : 'p'
    let l:name = a:put_before ? 'YanksBefore' : 'YanksAfter'
    let l:spec = {}
    let l:spec['source'] = map(miniyank#read(), {k,v -> k.' '.join(v[0], '\n')})
    let l:spec['sink'] = {val -> Sink(l:put_action, val)}
    let l:spec['options'] = '--no-sort --prompt="Yanks-'.l:put_action.'> "'
    call fzf#run(fzf#wrap(l:name, l:spec, a:fullscreen))
endfunction

if !empty('g:loaded_fzf')
    command! -bang YanksBefore call s:fzf_miniyank(1, <bang>0)
    command! -bang YanksAfter call s:fzf_miniyank(0, <bang>0)

    map <A-p> :YanksAfter<CR>
    map <A-P> :YanksBefore<CR>
endif

function! plugins#miniyank#complete_yanks(findstart, base) abort
    if a:findstart
        " locate the start of the word
        let l:line = getline('.')
        let l:start = col('.') - 1
        while l:start > 0 && l:line[l:start - 1] =~# '\a'
            let l:start -= 1
        endwhile
        return l:start
    else
        " find months matching with "a:base"
        let l:src = map(miniyank#read(), {_,v -> trim(join(v[0], '\n'))})
        let l:res = []
        for l:m in l:src
            if l:m =~? '^' . a:base
                call add(l:res, l:m)
            endif
        endfor
        return l:res
    endif
endfunction
set completefunc=plugins#miniyank#complete_yanks

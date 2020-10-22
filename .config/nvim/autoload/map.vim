" map#save() :: Save all settings of a map for later restoring {{{1
function! map#save(keys, mode, global) abort
    let l:mappings = {}
    if a:global
        for l:key in a:keys
            let l:buf_local_map = maparg(l:key, a:mode, 0, 1)
            silent! execute a:mode.'unmap <buffer> '.l:key
            let l:map_info        = maparg(l:key, a:mode, 0, 1)
            let l:mappings[l:key] = !empty(l:map_info)
                \ ? l:map_info : {
                \ 'unmapped' : 1,
                \ 'buffer'   : 0,
                \ 'lhs'      : l:key,
                \ 'mode'     : a:mode,
                \ }
            call map#restore({l:key : l:buf_local_map})
        endfor

    else
        for l:key in a:keys
            let l:map_info        = maparg(l:key, a:mode, 0, 1)
            let l:mappings[l:key] = !empty(l:map_info)
                \ ? l:map_info : {
                \ 'unmapped' : 1,
                \ 'buffer'   : 1,
                \ 'lhs'      : l:key,
                \ 'mode'     : a:mode,
                \ }
        endfor
    endif
    return l:mappings
endfunction

" map#restore() :: Restore saved map {{{1
function! map#restore(mappings) abort
    for l:mapping in values(a:mappings)
        if !has_key(l:mapping, 'unmapped') && !empty(l:mapping)
            execute l:mapping.mode
                \ .(l:mapping.noremap ? 'noremap   ' : 'map ')
                \ .(l:mapping.buffer  ? ' <buffer> ' : '')
                \ .(l:mapping.expr    ? ' <expr>   ' : '')
                \ .(l:mapping.nowait  ? ' <nowait> ' : '')
                \ .(l:mapping.silent  ? ' <silent> ' : '')
                \ . l:mapping.lhs
                \ . ' '
                \ . substitute(l:mapping.rhs, '<SID>', '<SNR>'.l:mapping.sid.'_', 'g')
        elseif has_key(l:mapping, 'unmapped')
            silent! execute l:mapping.mode.'unmap '
                \ .(l:mapping.buffer ? ' <buffer> ' : '')
                \ . l:mapping.lhs
        endif
    endfor
endfunction

" map#cabbr() :: Safe expansion of command-line abbreviations {{{1
function! map#cabbr(lhs, rhs) abort
    if getcmdtype() ==# ':' && getcmdline() ==# a:lhs
        if type(a:rhs) == v:t_func
            return a:rhs()
        endif
        return a:rhs
    endif
    return a:lhs
endfunction

" map#set_cabbr() :: Create safe cnoreabbrev {{{1
function! map#set_cabbr(from, to) abort
    execute 'cnoreabbrev <expr>' a:from
        \ '((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" map#eatchar() :: Eat character if it matches pattern {{{1
" From :helpgrep Eatchar
function! map#eatchar(pat) abort
    let l:c = nr2char(getchar(0))
    return (l:c =~ a:pat) ? '' : l:c
endfunc

" map#save() :: Save all settings of a map for later restoring {{{1
function map#save(keys, mode, global)
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
function map#restore(mappings)
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

" s:safe_abbr() :: Safe expansion of command-line abbreviations {{{1
function s:safe_cabbr(lhs, rhs)
    if getcmdtype() ==# ':' && getcmdline() ==# a:lhs
        if type(a:rhs) == v:t_func
            return a:rhs()
        endif
        return a:rhs
    endif
    return a:lhs
endfunction

" map#set_cabbr() :: Create safe cnoreabbrev {{{1
function map#set_cabbr(from, to)
    execute printf('cnoreabbrev <expr> %s getcmdtype() ==# ":" && getcmdline() ==# %s ? %s : %s',
        \ a:from,
        \ string(a:from),
        \ string(a:to),
        \ string(a:from),
        \ )
endfunction

function map#cabbr(lhs, rhs)
    execute printf('cnoreabbrev <expr> %s <SID>safe_cabbr(%s, %s)',
        \ a:lhs,
        \ string(a:lhs),
        \ string(a:rhs),
        \ )
endfunction

" map#eatchar() :: Eat character if it matches pattern {{{1
" From :helpgrep Eatchar
function map#eatchar(pat)
    let l:c = nr2char(getchar(0))
    return (l:c =~ a:pat) ? '' : l:c
endfunction

" map#check_back_space() :: Helper for tab mappings and completion {{{1
function map#check_back_space()
  let l:col = col('.') -1
  return !l:col || getline('.')[l:col - 1] =~# '\s'
endfunction

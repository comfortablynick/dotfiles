" ====================================================
" Filename:    autoload/map.vim
" Description: Utilities to assist with mapping/unmapping
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-20 15:07:22 CST
" ====================================================
if exists('g:loaded_autoload_map') | finish | endif
let g:loaded_autoload_map = 1

function! map#save(keys, mode, global) abort
    let l:mappings = {}
    if a:global
        for l:key in a:keys
            let buf_local_map = maparg(l:key, a:mode, 0, 1)
            silent! execute a:mode.'unmap <buffer> '.l:key
            let map_info        = maparg(l:key, a:mode, 0, 1)
            let l:mappings[l:key] = !empty(map_info)
                \ ? map_info : {
                \ 'unmapped' : 1,
                \ 'buffer'   : 0,
                \ 'lhs'      : l:key,
                \ 'mode'     : a:mode,
                \ }
            call map#restore({l:key : buf_local_map})
        endfor

    else
        for l:key in a:keys
            let map_info        = maparg(l:key, a:mode, 0, 1)
            let l:mappings[l:key] = !empty(map_info)
                \ ? map_info : {
                \ 'unmapped' : 1,
                \ 'buffer'   : 1,
                \ 'lhs'      : l:key,
                \ 'mode'     : a:mode,
                \ }
        endfor
    endif
    return l:mappings
endfunction

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

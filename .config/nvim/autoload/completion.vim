" ====================================================
" Filename:    autoload/completion.vim
" Description: Completion plugin config
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_autoload_completion' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Get completion type for a filetype, or empty string
function! completion#get_type(ftype) abort
    let l:types = get(g:, 'completion_filetypes', {})
    for l:key in keys(l:types)
        for l:val in l:types[l:key]
            if l:val ==? a:ftype
                return l:key
            endif
        endfor
    endfor
    return ''
endfunction

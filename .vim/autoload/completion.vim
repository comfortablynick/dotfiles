" ====================================================
" Filename:    autoload/completion.vim
" Description: Completion plugin config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-16 10:36:46 CST
" ====================================================

" Get completion type for a filetype, or empty string
function! completion#get_type(ftype) abort
    let l:types = get(g:, 'completion_filetypes', {})
    for key in keys(l:types)
        for val in l:types[key]
            if val ==? a:ftype
                return key
            endif
        endfor
    endfor
    return ''
endfunction

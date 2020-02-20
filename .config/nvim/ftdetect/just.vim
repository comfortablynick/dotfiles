" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile Justfile,justfile call s:set_just_filetype()

function! s:set_just_filetype() abort
    if &filetype !=# 'just'
        set filetype=just
    endif
endfunction

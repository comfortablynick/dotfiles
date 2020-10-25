" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile Justfile,justfile call s:set_just_filetype()

function! s:set_just_filetype()
    if &filetype !=# 'just'
        set filetype=just
    endif
endfunction

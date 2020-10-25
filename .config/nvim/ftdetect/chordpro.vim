" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile *.pro call s:set_chordpro_filetype()

function! s:set_chordpro_filetype()
    if &filetype !=# 'chordpro'
        set filetype=chordpro
    endif
endfunction

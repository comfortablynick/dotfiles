" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile *.fish call s:set_fish_filetype()

function! s:set_fish_filetype() abort
    if &filetype !=# 'fish'
        set filetype=fish
    endif
endfunction

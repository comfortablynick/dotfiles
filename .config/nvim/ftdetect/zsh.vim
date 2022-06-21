" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile **/zsh/* call s:set_filetype()

function s:set_filetype() abort
    " vim reads zsh files as conf or no filetype by default it seems
    if &filetype =~# 'conf\|'
        set filetype=zsh
    endif
endfunction

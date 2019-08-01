" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile *.envrc call s:set_envrc_filetype()

function! s:set_envrc_filetype() abort
    if &filetype !=# 'envrc'
        set filetype=sh
    endif
endfunction

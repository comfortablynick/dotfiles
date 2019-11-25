" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile *.snippets call s:set_snippets_filetype()

function! s:set_snippets_filetype() abort
    if &filetype !=# 'snippets'
        set filetype=snippets
    endif
endfunction

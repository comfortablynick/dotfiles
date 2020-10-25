" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile go.mod call s:set_go_filetype()

function! s:set_go_filetype()
    if &filetype !=# 'go'
        set filetype=go
    endif
endfunction

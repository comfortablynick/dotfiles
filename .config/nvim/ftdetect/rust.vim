" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile *.crs call s:set_crs_filetype()

function! s:set_crs_filetype()
    if &filetype !=# 'rust'
        set filetype=rust
    endif
endfunction

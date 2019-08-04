" vint: -ProhibitAutocmdWithNoGroup

" autocmd BufRead,BufNewFile justfile call s:set_make_filetype()
"
" function! s:set_make_filetype() abort
"     if &filetype !=# 'make'
"         set filetype=make
"     endif
" endfunction

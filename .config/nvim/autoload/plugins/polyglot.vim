function! plugins#polyglot#pre()
    " Don't use polyglot syntax files for these filetypes
    let g:polyglot_disabled = [
        \ 'markdown',
        \ 'asciidoc',
        \ ]
endfunction

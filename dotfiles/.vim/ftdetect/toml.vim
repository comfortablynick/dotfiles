" For some reason, vim-toml doesn't detect all of these files using Vim
" packages. So we'll reuse their ftdetect logic here.

" vint: -ProhibitAutocmdWithNoGroup
autocmd BufNewFile,BufRead *.toml,Gopkg.lock,Cargo.lock,*/.cargo/config,*/.cargo/credentials,Pipfile call s:set_toml_filetype()

function! s:set_toml_filetype() abort
    if &filetype !=# 'toml'
        set filetype=toml
    endif
endfunction

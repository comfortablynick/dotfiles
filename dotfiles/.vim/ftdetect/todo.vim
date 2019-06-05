" vint: -ProhibitAutocmdWithNoGroup

autocmd BufNewFile,BufRead [Tt]odo.txt call s:set_todo_filetype()
autocmd BufNewFile,BufRead *.[Tt]odo.txt call s:set_todo_filetype()
autocmd BufNewFile,BufRead [Dd]one.txt call s:set_todo_filetype()
autocmd BufNewFile,BufRead *.[Dd]one.txt call s:set_todo_filetype()

function! s:set_todo_filetype() abort
    if &filetype !=# 'todo'
        set filetype=todo
    endif
endfunction

setlocal tabstop=4
setlocal formatoptions-=cro
setlocal makeprg=vint\ %
let g:vim_indent_cont = &tabstop

" Maps
" Execute visual selection
vnoremap <silent><buffer> <Enter> "xy:@x<CR>
" Execute line
nnoremap <buffer> yxx   <Cmd>execute trim(getline('.'))<CR>
nnoremap <buffer> <C-]> <Cmd>call pack#lazy_run({-> lookup#lookup()}, 'vim-lookup')<CR>
nnoremap <buffer> <C-t> <Cmd>call pack#lazy_run({-> lookup#pop()}, 'vim-lookup')<CR>

" Turn maps into <Cmd> type
nnoremap <buffer> ycc
    \ <Cmd>call setline('.', substitute(getline('.'), '\(^.\+\)\(<silent>\s*\)\(.\+\)\(:\)\(.\+$\)', '\1\3\<Cmd\>\5', ''))<CR>

" Change variable under cursor to local type
nnoremap <buffer> glo
    \ <Cmd>call v:lua.require('config.lsp').simple_rename('l:'..expand('<cword>'))<CR>

function VimFoldLevel()
    let l:marker = split(&foldmarker, ',')[0]
    let l:line = getline(v:lnum)
    " Functions
    if l:line =~# '\v^\s*fun'
        return '>1'
    endif
    " Modeline (don't fold)
    if l:line =~# '\v^\"\s*vim:'
        return '0'
    endif
    " Markers
    " TODO: extract number for level
    if l:line =~# '{{{\d*$'
        return '>1'
    endif
    return '='
endfunction

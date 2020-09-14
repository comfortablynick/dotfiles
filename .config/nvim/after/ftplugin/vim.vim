setlocal tabstop=4                                              " Treat spaces as tab
setlocal formatoptions-=o                                       " Don't insert comment marker automatically on O, o
setlocal formatoptions-=r                                       " Don't insert comment marker automatically on <Enter>
setlocal foldmethod=marker
setlocal foldexpr=VimFoldLevel()
let g:vim_indent_cont = &tabstop                                " Indent \ newline escapes

" Maps
" Execute visual selection
vnoremap <silent><buffer> <Enter> "xy:@x<CR>
" Execute line
nnoremap <silent><buffer> yxx   :execute trim(getline('.'))<CR>
nnoremap <silent><buffer> <C-]> :call plugins#lazy_run({-> lookup#lookup()}, 'vim-lookup')<CR>
nnoremap <silent><buffer> <C-t> :call plugins#lazy_run({-> lookup#pop()}, 'vim-lookup')<CR>

function! VimFoldLevel() abort
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
    " let fdl = matchstr(line, '{{{')
    " if !empty(fdl)
    "     let fl = matchstr(line, '{{{\d')
    "     if fl > 0
    "         return fl
    "     endif
    "     return '>1'
    " endif
    return '='
endfunction

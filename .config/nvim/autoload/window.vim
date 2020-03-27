let s:guard = 'g:loaded_autoload_window' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Get usable width of window
" Adapted from https://stackoverflow.com/a/52921337/10370751
function! window#width() abort
    let l:width = winwidth(0)
    let l:numberwidth = max([&numberwidth, strlen(line('$')) + 1])
    let l:numwidth = (&number || &relativenumber) ? l:numberwidth : 0
    let l:foldwidth = &foldcolumn
    let l:signwidth = 0

    if &signcolumn ==# 'yes'
        let l:signwidth = 2
    elseif &signcolumn ==# 'auto'
        let l:signs = execute('sign place buffer='.bufnr(''))
        let l:signs = split(l:signs, "\n")
        let l:signwidth = len(l:signs) > 2 ? 2 : 0
    endif
    return l:width - l:numwidth - l:foldwidth - l:signwidth
endfunction

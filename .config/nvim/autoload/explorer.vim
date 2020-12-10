" Allow for netrw to be toggled
function! s:toggle_netrw()
    if exists('g:NetrwIsOpen')
        let l:netrw_bufs = filter(getbufinfo(), {_,v-> getbufvar(v.bufnr, '&filetype') ==# 'netrw'})
        for l:buf in l:netrw_bufs
            silent execute 'bwipeout' l:buf.bufnr
        endfor
        unlet! g:NetrwIsOpen
    else
        silent Lexplore
        let g:NetrwIsOpen = 1
    endif
endfunction

" Toggles explorer buffer
function! explorer#toggle(explorer)
    if a:explorer ==# 'nerdtree'
        NERDTreeToggle
    elseif a:explorer ==# 'coc-explorer'
        CocCommand explorer --toggle
    elseif a:explorer ==# 'defx'
        DefxToggle
    elseif a:explorer ==# 'rnvimr'
        RnvimrToggle
    else
        call s:toggle_netrw()
    endif
endfunction

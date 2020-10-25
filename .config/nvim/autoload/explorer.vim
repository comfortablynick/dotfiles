" Allow for netrw to be toggled
function! s:toggle_netrw()
    if get(g:, 'NetrwIsOpen', 0)
        let l:i = bufnr('$')
        while (l:i >= 1)
            if (getbufvar(l:i, '&filetype') ==# 'netrw')
                silent exe 'bwipeout '.l:i
            endif
            let l:i-=1
        endwhile
        let g:NetrwIsOpen = 0
    else
        let g:NetrwIsOpen = 1
        silent Lexplore
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

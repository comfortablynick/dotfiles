" ====================================================
" Filename:    autoload/explorer.vim
" Description: File explorer settings
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_autoload_explorer' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Allow for netrw to be toggled
function! s:toggle_netrw() abort
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
function! explorer#toggle(explorer) abort
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

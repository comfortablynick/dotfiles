" ====================================================
" Filename:    autoload/explorer.vim
" Description: File explorer settings
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_autoload_explorer' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" function! s:netrw_run() abort
"     if exists('t:expl_buf_num')
"         " TODO: throws error if called from non-netrw buffer
"         let l:expl_win_num = bufwinnr(t:expl_buf_num)
"         let l:cur_win_nr = winnr()
"         if l:expl_win_num != -1
"             while l:expl_win_num != l:cur_win_nr
"                 exec 'wincmd w'
"                 let l:cur_win_nr = winnr()
"             endwhile
"             close
"         endif
"         unlet t:expl_buf_num
"     else
"         Lexplore
"         let t:expl_buf_num = bufnr('%')
"     endif
" endfunction

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
        if !exists(':NERDTreeToggle') | packadd nerdtree | endif
        exe 'NERDTreeToggle'
    elseif a:explorer ==# 'coc-explorer'
        exe 'CocCommand explorer --toggle'
    elseif a:explorer ==# 'defx'
        if !exists('*defx#do_action') | packadd defx.nvim | endif
        exe 'Defx -toggle -split=vertical -winwidth=30 -direction=topleft'
    else
        call s:toggle_netrw()
    endif
endfunction

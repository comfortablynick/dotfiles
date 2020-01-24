" ====================================================
" Filename:    autoload/explorer.vim
" Description: File explorer functions/settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-24 12:56:52 CST
" ====================================================

function! s:netrw_set_opts() abort
    if exists('g:netrw_set_opts') | return | endif
    let g:netrw_set_opts = 1
    let g:netrw_liststyle = 3
    let g:netrw_browse_split = 4
    let g:netrw_altv = 1
    let g:netrw_winsize = -30 " Absolute
    let g:netrw_banner = 0
    let g:netrw_list_hide = &wildignore
    let g:netrw_sort_sequence = '[\/]$,*' " Directories on the top, files below
endfunction

function! s:netrw_run() abort
    if exists('t:expl_buf_num')
        " TODO: throws error if called from non-netrw buffer
        let l:expl_win_num = bufwinnr(t:expl_buf_num)
        let l:cur_win_nr = winnr()
        if l:expl_win_num != -1
            while l:expl_win_num != l:cur_win_nr
                exec 'wincmd w'
                let l:cur_win_nr = winnr()
            endwhile
            close
        endif
        unlet t:expl_buf_num
    else
        Lexplore
        let t:expl_buf_num = bufnr('%')
    endif
endfunction


" Toggles explorer buffer
function! explorer#toggle_v_explorer() abort
    let g:use_explorer = get(g:, 'use_explorer', 'netrw')
    if g:use_explorer ==# 'nerdtree'
        if !exists(':NERDTreeToggle') | packadd nerdtree | endif
        exe 'NERDTreeToggle'
    elseif g:use_explorer ==# 'coc-explorer'
        exe 'CocCommand explorer --toggle'
    elseif g:use_explorer ==# 'defx'
        if !exists(':Defx') | packadd defx.nvim | endif
        exe 'Defx -toggle -split=vertical -winwidth=30 -direction=topleft'
    else
        call s:netrw_set_opts()
        call s:netrw_run()
    endif
endfunction

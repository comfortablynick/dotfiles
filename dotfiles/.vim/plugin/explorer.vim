" ====================================================
" Filename:    plugin/explorer.vim
" Description: Handle project file explorer settings such as netrw or NERDTree
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-11-23
" ====================================================
if exists('g:loaded_explorer_vim') | finish | endif
let g:loaded_explorer_vim = 1

let g:use_explorer = 'netrw'         " netrw/nerdtree/coc-explorer (set from coc config)

" NERDTree
let NERDTreeHighlightCursorline = 1
let NERDTreeIgnore = [
    \ '\.pyc$',
    \ '^__pycache__$',
    \ '.vscode',
    \ ]
let NERDTreeShowHidden = 1
let NERDTreeQuitOnOpen = 1

" netrw
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_banner = 0
let g:netrw_list_hide = &wildignore

" Toggles explorer buffer
function! s:toggle_v_explorer() abort
    if get(g:, 'use_explorer', 'netrw') ==# 'nerdtree'
        packadd nerdtree
        exe 'NERDTreeToggle'
    elseif get(g:, 'use_explorer', 'netrw') ==# 'coc-explorer'
        exe 'CocCommand explorer --toggle'
    elseif exists('t:expl_buf_num')
        " TODO: throws error if called from non-netrw buffer
        let expl_win_num = bufwinnr(t:expl_buf_num)
        if expl_win_num != -1
            let cur_win_nr = winnr()
            exec expl_win_num . 'wincmd w'
            close
            exec cur_win_nr . 'wincmd w'
            unlet t:expl_buf_num
        else
            unlet t:expl_buf_num
        endif
    else
        exec '1wincmd w'
        Vexplore
        let t:expl_buf_num = bufnr('%')
    endif
endfunction

" Mapping
nnoremap <silent> <Leader>n :call <SID>toggle_v_explorer()<CR>

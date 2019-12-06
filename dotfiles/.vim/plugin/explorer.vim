" ====================================================
" Filename:    plugin/explorer.vim
" Description: Handle project file explorer settings such as netrw or NERDTree
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-06
" ====================================================
if exists('g:loaded_plugin_explorer_eblucpym') | finish | endif
let g:loaded_plugin_explorer_eblucpym = 1

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

augroup plugin_explorer_eblucpym
    autocmd!
    autocmd FileType netrw call s:netrw_maps()
augroup END

function! s:netrw_maps() abort
    nnoremap <silent><buffer> <C-L> :TmuxNavigateRight<CR>
    nnoremap <buffer> <silent> <nowait> <CR> <Plug>NetrwLocalBrowseCheck
endfunction

function! s:use_netrw() abort
    if !exists('g:loaded_netrw_options')
        let g:loaded_netrw_options = 1

        let g:netrw_liststyle = 3
        let g:netrw_browse_split = 4
        let g:netrw_altv = 1
        let g:netrw_winsize = -30 " Absolute
        let g:netrw_banner = 0
        let g:netrw_list_hide = &wildignore
        let g:netrw_sort_sequence = '[\/]$,*' " Directories on the top, files below
    endif
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
        " exec '1wincmd w'
        " Vexplore
        Lexplore
        let t:expl_buf_num = bufnr('%')
    endif
endfunction

" Toggles explorer buffer
function! s:toggle_v_explorer() abort
    let g:use_explorer = get(g:, 'use_explorer', 'netrw')
    if g:use_explorer ==# 'nerdtree'
        packadd nerdtree
        exe 'NERDTreeToggle'
    elseif g:use_explorer ==# 'coc-explorer'
        exe 'CocCommand explorer --toggle'
    else
        call s:use_netrw()
    endif
endfunction

" Mapping
nnoremap <silent> <Leader>n :call <SID>toggle_v_explorer()<CR>
nnoremap <silent>    <C-E>  :call <SID>toggle_v_explorer()<CR>

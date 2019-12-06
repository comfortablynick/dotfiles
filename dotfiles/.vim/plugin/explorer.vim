" ====================================================
" Filename:    plugin/explorer.vim
" Description: Handle project file explorer settings such as netrw or NERDTree
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-06
" ====================================================
if exists('g:loaded_plugin_explorer_eblucpym') | finish | endif
let g:loaded_plugin_explorer_eblucpym = 1

let g:use_explorer = 'defx'         " netrw/nerdtree/defx/coc-explorer (set from coc config)

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
	autocmd FileType defx  call s:defx_maps()
augroup END

function! s:defx_maps() abort
    nnoremap <silent><buffer><expr> <CR>
    \ defx#do_action('open')
    nnoremap <silent><buffer><expr> c
    \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
    \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
    \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
    \ defx#do_action('open')
    nnoremap <silent><buffer><expr> s
    \ defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> P
    \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> o
    \ defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> K
    \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
    \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
    \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> C
    \ defx#do_action('toggle_columns',
    \                'mark:indent:icon:filename:type:size:time')
    nnoremap <silent><buffer><expr> S
    \ defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr> d
    \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
    \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> !
    \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x
    \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
    \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
    \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> ;
    \ defx#do_action('repeat')
    nnoremap <silent><buffer><expr> h
    \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
    \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
    \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
    \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
    \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
    \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
    \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
    \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
    \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
    \ defx#do_action('change_vim_cwd')
endfunction

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
    elseif g:use_explorer ==# 'defx'
        packadd defx.nvim
        exe 'Defx -split=vertical -winwidth=30 -direction=topleft'
    else
        call s:use_netrw()
    endif
endfunction

" Mapping
nnoremap <silent> <Leader>n :call <SID>toggle_v_explorer()<CR>
nnoremap <silent>    <C-E>  :call <SID>toggle_v_explorer()<CR>

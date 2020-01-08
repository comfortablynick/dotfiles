" ====================================================
" Filename:    plugin/explorer.vim
" Description: Handle project file explorer settings such as netrw or NERDTree
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:46:46 CST
" ====================================================
if exists('g:loaded_plugin_explorer_eblucpym')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_explorer_eblucpym = 1

" let g:use_explorer = 'defx'         " netrw/nerdtree/defx/coc-explorer (set from coc config)

" Mapping
nnoremap <silent> <Leader>n :call explorer#toggle_v_explorer()<CR>
nnoremap <silent>    <C-E>  :call explorer#toggle_v_explorer()<CR>

augroup loaded_plugin_explorer_eblucpym
    autocmd!
    autocmd FileType defx call s:defx_set_maps()
    autocmd FileType netrw call s:netrw_set_maps()
augroup END

function! s:netrw_set_maps() abort
    nnoremap <buffer><silent><C-L> :TmuxNavigateRight<CR>
    " nmap <buffer><silent><nowait> <CR> <Plug>(NetrwLocalBrowseCheck)
endfunction

function! s:defx_set_maps() abort
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
    " nnoremap <silent><buffer><expr> <C-l>
    "     \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd')
endfunction

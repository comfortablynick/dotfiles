" ====================================================
" Filename:    plugin/explorer.vim
" Description: Handle project file explorer plugin settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-24 12:57:48 CST
" ====================================================
if exists('g:loaded_plugin_explorer_eblucpym')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_explorer_eblucpym = 1

let g:use_explorer = 'defx'         " netrw/nerdtree/defx/coc-explorer (set from coc config)

" Commands
command -nargs=0 TagbarToggle call plugins#tagbar#toggle()

" Maps
nnoremap <silent> <Leader>n :call explorer#toggle_v_explorer()<CR>
nnoremap <silent>    <C-E>  :call explorer#toggle_v_explorer()<CR>

augroup loaded_plugin_explorer_eblucpym
    autocmd!
    autocmd FileType netrw call s:netrw_set_maps()
augroup END

function! s:netrw_set_maps() abort
    nnoremap <buffer><silent><C-L> :TmuxNavigateRight<CR>
    " nmap <buffer><silent><nowait> <CR> <Plug>(NetrwLocalBrowseCheck)
endfunction

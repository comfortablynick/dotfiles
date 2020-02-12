" ====================================================
" Filename:    plugin/explorer.vim
" Description: Handle project file explorer plugin settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-26 12:51:12 CST
" ====================================================
if exists('g:loaded_plugin_explorer')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_explorer_eblucpym = 1

let g:use_explorer = 'defx'             " netrw/nerdtree/defx/coc-explorer (set from coc config)
let g:use_explorer_coc = 'coc-explorer' " use with coc.nvim

" Commands
command -nargs=0 TagbarToggle call plugins#tagbar#toggle()

" Maps
nnoremap <silent> <Leader>n :call explorer#toggle_v_explorer()<CR>
nnoremap <silent>    <C-E>  :call explorer#toggle_v_explorer()<CR>

augroup loaded_plugin_explorer
    autocmd!
    autocmd FileType netrw call s:netrw_set_maps()
augroup END

function! s:netrw_set_maps() abort
    nnoremap <buffer><silent><C-L> :TmuxNavigateRight<CR>
    " nmap <buffer><silent><nowait> <CR> <Plug>(NetrwLocalBrowseCheck)
endfunction
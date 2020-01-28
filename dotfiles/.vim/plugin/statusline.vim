" ====================================================
" Filename:    plugin/statusline.vim
" Description: Set statusline
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-28 08:42:18 CST
" ====================================================
if exists('g:loaded_plugin_statusline')
    \ || exists('*lightline#update')
    finish
endif
let g:loaded_plugin_statusline = 1

let &statusline = printf(
    \ ' %%-6{%s} %%<%%-18{%s} %%-20{%s}',
    \ 'v:lua.ll.vim_mode()',
    \ 'v:lua.ll.file_name()',
    \ 'v:lua.ll.git_status()',
    \ )
let &statusline .= printf(
    \ '%%=%%{%s} ',
    \ 'v:lua.ll.line_info()',
    \ )
" set statusline+=\ %{v:lua.ll.vim_mode()}
" set statusline+=\ %{v:lua.ll.file_name()}
" " set statusline+=\ \|
" set statusline+=\ %{v:lua.ll.git_status()}
" set statusline+=\ %{v:lua.ll.linter_errors()}
" set statusline+=\ %{v:lua.ll.linter_warnings()}

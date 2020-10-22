" Autoclose vim if last window is not a file
" Original script from: https://stackoverflow.com/a/39307414/10370751
let g:autoclose_buftypes = [
    \ 'quickfix',
    \ 'help',
    \ 'nofile',
    \ ]
let g:autoclose_filetypes = [
    \ 'qf',
    \ 'help',
    \ 'vista',
    \ 'minpac',
    \ 'vim-plug',
    \ 'coc-explorer',
    \ 'defx',
    \ ]

" TODO: find a way to do this without side effects
" autoclose last open location/quickfix/help windows on a tab
" augroup plugin_autoclose
"     autocmd!
"     autocmd WinEnter * ++nested call autoclose#quit_if_only_window()
" augroup END

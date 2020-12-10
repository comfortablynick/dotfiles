if !exists(':Cfilter') | packadd cfilter | endif

setlocal nolist
setlocal norelativenumber
setlocal nobuflisted
setlocal cursorline

" augroup after_ftplugin_qf
"     autocmd!
"     " quit Vim if the last window is a quickfix window
"     autocmd BufEnter <buffer> ++nested  if get(g:, 'qf_auto_quit', 1) && winnr('$') < 2 | q | endif
"     " autocmd QuickFixCmdPost l*    if get(g:, 'qf_auto_open', 1) | lwindow | endif
"     " autocmd QuickFixCmdPost [^l]* if get(g:, 'qf_auto_open', 1) | cwindow | endif
" augroup END

" are we in a location list or a quickfix list?
let b:qf_is_loc = !empty(getloclist(0))

nnoremap <silent><buffer> <Left>  :call quickfix#older()<CR>
nnoremap <silent><buffer> <Right> :call quickfix#newer()<CR>
nnoremap <silent><buffer> q       :call buffer#quick_close()<CR>

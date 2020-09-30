if !exists(':Cfilter') | packadd cfilter | endif

setlocal nolist norelativenumber

augroup after_ftplugin_qf
    autocmd!
    " quit Vim if the last window is a quickfix window
    autocmd BufEnter <buffer> ++nested  if get(g:, 'qf_auto_quit', 1) && winnr('$') < 2 | q | endif
    " autocmd QuickFixCmdPost l*    if get(g:, 'qf_auto_open', 1) | lwindow | endif
    " autocmd QuickFixCmdPost [^l]* if get(g:, 'qf_auto_open', 1) | cwindow | endif
    autocmd QuickFixCmdPost * cwindow
augroup END

nnoremap <silent> <buffer> <Left> :call quickfix#older()<CR>
nnoremap <silent> <buffer> <Right> :call quickfix#newer()<CR>

" Autoclose vim if last window is not a file
" Original script from: https://stackoverflow.com/a/39307414/10370751
if exists('g:loaded_autoclose')
    finish
endif
let g:loaded_autoclose = 1

" autoclose last open location/quickfix/help windows on a tab
augroup AutoCloseAllQF
    autocmd!
    autocmd WinEnter * nested call autoclose#quit_if_only_window()
augroup END

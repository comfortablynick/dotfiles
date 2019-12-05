if exists('g:loaded_ftplugin_go_gdqna1rp') | finish | endif
let g:loaded_ftplugin_go_gdqna1rp = 1

" Golang Options
setlocal formatoptions-=t                                       " Don't autowrap text

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal noexpandtab                                            " Don't convert tab to spaces (gofmt uses tabs)
let &l:tabstop = winwidth(0) > 150 ? 8 : 4                      " View tabs as 8 spaces (std) if window is wide enough
" let b:coc_disable_cursorhold_hover = 1                          " Disable coc hover autocmd on CursorHold (can use manually)

compiler go

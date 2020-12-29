setlocal formatoptions-=crot
setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal nolist                                                 " No tab characters
setlocal noexpandtab                                            " Don't convert tab to spaces (gofmt uses tabs)
setlocal foldmethod=marker

let &l:tabstop = winwidth(0) > 150 ? 8 : 4                      " View tabs as 8 spaces (std) if window is wide enough

compiler go
let b:undo_ftplugin .= '|setl fo< com< list< et< fdm< ts<'

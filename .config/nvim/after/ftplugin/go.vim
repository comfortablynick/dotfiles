" Golang Options
setlocal formatoptions-=t                                       " Don't autowrap text
setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal nolist                                                 " No tab characters
setlocal noexpandtab                                            " Don't convert tab to spaces (gofmt uses tabs)

let &l:tabstop = winwidth(0) > 150 ? 8 : 4                      " View tabs as 8 spaces (std) if window is wide enough

compiler go

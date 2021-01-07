let g:lua_syntax_nofold = 1

" Override vim ftplugin and set not to add comment leader on new line
setlocal tabstop=2 shiftwidth=0
setlocal formatoptions-=cro
setlocal formatprg=lua-format
setlocal foldmethod=marker

packadd nvim-luadev
vmap <buffer><Enter> <Plug>(Luadev-Run)
nmap <buffer>grl     <Plug>(Luadev-RunLine)

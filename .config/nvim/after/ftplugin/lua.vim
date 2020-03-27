let g:lua_syntax_nofold = 1

" Override vim ftplugin and set not to add comment leader on new line
setlocal tabstop=2 shiftwidth=0
setlocal formatoptions-=o formatoptions-=r
setlocal formatprg=lua-format\ --config=$XDG_CONFIG_HOME/.lua-format

silent! packadd nvim-luadev

if exists(':Luadev')
    map lr   <Plug>(Luadev-Run)
    map lrl  <Plug>(Luadev-RunLine)
endif

" Embed lua (works for neovim)
if g:vimsyn_embed =~# 'l'
    unlet! b:current_syntax
    syntax include @vimLuaScript syntax/lua.vim
    " Include after/syntax if exists
    silent! syntax include @vimLuaScript after/syntax/lua.vim

    syn region  vimLuaRegion matchgroup=vimScriptDelim start=+lua\s*<<\s*\z(.*\)$+ end=+^\z1$+	contains=@vimLuaScript
    syn region  vimLuaRegion matchgroup=vimScriptDelim start=+lua\s*<<\s*$+ end=+\.$+		contains=@vimLuaScript
    syn cluster vimFuncBodyList add=vimLuaRegion

    let b:current_syntax = 'vim'
endif

syntax keyword vimCommand contained Pack[load] Plug[Local]

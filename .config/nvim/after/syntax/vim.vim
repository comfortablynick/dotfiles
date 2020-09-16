unlet! b:current_syntax
syn cluster vimFuncBodyList	add=vimPythonRegion
syntax include @vimPythonScript syntax/python.vim
try
    syntax include @vimPythonScript after/syntax/python.vim
catch
endtry
syn region vimPythonRegion matchgroup=vimScriptDelim start=+py\%[thon]3\=\s*<<\s*\z(\S*\)\ze\(\s*#.*\)\=$+ end=+^\z1\ze\(\s*".*\)\=$+	contains=@vimPythonScript
syn region vimPythonRegion matchgroup=vimScriptDelim start=+py\%[thon]3\=\s*<<\s*$+ end=+\.$+			contains=@vimPythonScript
syn cluster vimFuncBodyList	add=vimPythonRegion

unlet! b:current_syntax
syn cluster vimFuncBodyList	add=vimLuaRegion
syntax include @vimLuaScript syntax/lua.vim
try
    syntax include @vimLuaScript after/syntax/lua.vim
catch
endtry
syn region vimLuaRegion matchgroup=vimScriptDelim start=+lua\s*<<\s*\z(.*\)$+ end=+^\z1$+	contains=@vimLuaScript
syn region vimLuaRegion matchgroup=vimScriptDelim start=+lua\s*<<\s*$+ end=+\.$+		contains=@vimLuaScript
syn cluster vimFuncBodyList	add=vimLuaRegion
let b:current_syntax = 'vim'

syntax keyword vimCommand contained Pack

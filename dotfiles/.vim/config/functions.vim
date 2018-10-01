" VIM / NEOVIM FUNCTIONS

" Add shebang for new file
function! SetShebang()
python3 << endpython

import vim
shebang = {
	'python':     '#!/usr/bin/env python3',
	'sh':         '#!/usr/bin/env sh',
	'javascript': '#!/usr/bin/env node',
	'lua':        '#!/usr/bin/env lua',
	'ruby':       '#!/usr/bin/env ruby',
	'perl':       '#!/usr/bin/env perl',
	'php':        '#!/usr/bin/env php',
}
if not vim.current.buffer[0].startswith('#!'):
	filetype = vim.eval('&filetype')
	if filetype in shebang:
		vim.current.buffer[0:0] = [ shebang[filetype] ]
endpython
endfunction


" Get path of current file
function! GetPath()
python3 << EOP

import vim

file_path = vim.eval("expand('%:p')")
print(file_path)
EOP
endfunction


" Set executable bit
function! SetExecutableBit()
python3 << EOP

import os
import stat
import vim

file_path = vim.eval("expand('%:p')")
st = os.stat(file_path)
old_perms = stat.filemode(st.st_mode)
os.chmod(file_path, st.st_mode | 0o111)
new_st = os.stat(file_path)
new_perms = stat.filemode(new_st.st_mode)

if old_perms == new_perms:
    print(f"File already executable: {old_perms}")
else:
    print(f"File now executable; changed from {old_perms} to {new_perms}")
EOP
endfunction


" Set shebang and executable bit
function! SetExecutable()
    call SetExecutableBit()
    call SetShebang()
endfunction

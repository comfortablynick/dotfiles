let g:lua_syntax_nofold = 1

" Override vim ftplugin and set not to add comment leader on new line
setlocal tabstop=2 shiftwidth=0
setlocal formatoptions-=cro
setlocal formatprg=lua-format
setlocal foldmethod=marker
setlocal makeprg=luacheck\ %\ --formatter=plain\ --codes
setlocal errorformat=%f:%l:%c:\ (%t%*\\d)\ %m

packadd nvim-luadev
vmap <buffer><Enter> <Plug>(Luadev-Run)
nmap <buffer>grl     <Plug>(Luadev-RunLine)

" Preserve existing doge settings.
let b:doge_patterns = get(b:, 'doge_patterns', {})
let b:doge_supported_doc_standards = get(b:, 'doge_supported_doc_standards', [])
if index(b:doge_supported_doc_standards, 'ldoc-typed') < 0
    call add(b:doge_supported_doc_standards, 'ldoc-typed')
endif

" Set the new doc standard as default.
let b:doge_doc_standard = 'ldoc-typed'

" Ensure we do not overwrite an existing doc standard.
let b:doge_patterns['ldoc-typed'] = b:doge_patterns['ldoc']
let b:doge_patterns['ldoc-typed'][0]['parameters']['format'] = '@param {name} (!type) !description'

augroup after_ftplugin_lua
    autocmd!
    " Add {} for the `argument` text object
    " Autocmd will not fire if targets.vim is not installed
    autocmd User targets#mappings#user
        \ call targets#mappings#extend({'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]}})
augroup END

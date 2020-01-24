"  _       _ _         _
" (_)_ __ (_) |___   _(_)_ __ ___
" | | '_ \| | __\ \ / / | '_ ` _ \
" | | | | | | |_ \ V /| | | | | | |
" |_|_| |_|_|\__(_)_/ |_|_| |_| |_|
"
let g:use_init_lua = 1

augroup plugin_config_handler
    autocmd!
    autocmd! SourcePre * call s:source_handler(expand('<afile>'), 'pre')
    autocmd! SourcePost * call s:source_handler(expand('<afile>'), 'post')
augroup END

let g:plugin_config_files = map(split(globpath(&runtimepath, 'autoload/plugins/*'), '\n'), 'fnamemodify(v:val, ":t:r")')
let g:plugins_sourced = []

" TODO: refine globbing to only find plugin/*.vim files
function! s:source_handler(sourced, type) abort
    if a:type ==# 'pre'
        let g:plugins_sourced += [a:sourced]
    endif
    let l:file = fnamemodify(a:sourced, ':t:r')
    if index(g:plugin_config_files, l:file) > -1
        let l:funcname = printf('plugins#%s#%s()', tolower(l:file), a:type)
        execute 'silent! call' l:funcname
    endif
endfunction

if get(g:, 'use_init_lua') == 1
    lua require 'init'
else
    " Use vim files instead
    let config_list = ['config.vim', 'functions.vim', 'map.vim', 'theme.vim']
    let g:vim_home = get(g:, 'vim_home', expand('$HOME/dotfiles/dotfiles/.vim/config/'))

    for files in config_list
        for f in glob(g:vim_home.files, 1, 1)
            exec 'source' f
        endfor
    endfor

endif

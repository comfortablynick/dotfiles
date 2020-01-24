" ====================================================
" Filename:    plugin/pack.vim
" Description: Interface with packages and package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-23 17:23:11 CST
" ====================================================
if exists('g:loaded_plugin_pack_gdjlcrz2')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_pack_gdjlcrz2 = 1

let g:package_manager = 'vim-packager'

" Call minpac or minpac wrappers
command! -bang PackUpdate call plugins#init() | call pack#update({'force_hooks': <bang>0})
command!       PackClean  call plugins#init() | call pack#clean()
command!       PackStatus call plugins#init() | call pack#status()


augroup after_plugin_editor_cv2f0oda
    autocmd!
    autocmd! SourcePre * call s:pre_handler(expand('<afile>'))
    autocmd! SourcePost * call s:post_handler(expand('<afile>'))
augroup END

let g:plugin_config_files = map(split(globpath(&runtimepath, 'autoload/plugins/*'), '\n'), 'fnamemodify(v:val, ":t:r")')
let g:plugins_sourced = []

" TODO: refine globbing to only find plugin/*.vim files
function! s:pre_handler(sourced) abort
    let g:plugins_sourced += [a:sourced]
    let l:file = fnamemodify(a:sourced, ':t:r')
    if index(g:plugin_config_files, l:file) > -1
        let l:funcname = 'plugins#'.l:file.'#pre()'
        execute 'silent! call' l:funcname
    endif
endfunction

function! s:post_handler(sourced) abort
    let l:file = fnamemodify(a:sourced, ':t:r')
    if index(g:plugin_config_files, l:file) > -1
        let l:funcname = 'plugins#'.l:file.'#post()'
        execute 'silent! call' l:funcname
    endif
endfunction

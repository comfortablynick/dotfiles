" ====================================================
" Filename:    plugin/pack.vim
" Description: Interface with packages and package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-29 01:01:04 CST
" ====================================================
let s:guard = 'g:loaded_plugin_pack' | if exists(s:guard) | finish | endif
let {s:guard} = 1

let g:package_manager = 'vim-packager'

let g:package_defer_time = 300

" Call minpac or minpac wrappers
command!       PackInstall call plugins#init() | call pack#install()
command! -bang PackUpdate  call plugins#init() | call pack#update({'force_hooks': <bang>0})
command!       PackClean   call plugins#init() | call pack#clean()
command!       PackStatus  call plugins#init() | call pack#status()

augroup deferred_pack_load
    autocmd!
    autocmd VimEnter * ++once call timer_start(g:package_defer_time, { -> s:deferred_load() })
    autocmd FileType * call timer_start(g:package_defer_time, { -> s:deferred_load_filetype() })
augroup END

" Load packages that are safe to defer
function! s:deferred_load() abort
    silent! packadd targets.vim
    silent! packadd tcomment_vim
    silent! packadd asyncrun.vim
    silent! packadd vim-vinegar
    " silent! packadd vim-dispatch
    " silent! packadd vim-easymotion
    silent! packadd clever-f.vim
    silent! packadd vim-sneak

    if $MOSH_CONNECTION != 1
        silent! packadd vim-devicons
    endif

    " Load local vimrc if env var
    call localrc#load_from_env()
endfunction

function! s:deferred_load_filetype() abort
    let l:comptype = completion#get_type(&filetype)
    if l:comptype ==# 'mucomplete' || l:comptype ==# 'nvim-lsp'
        silent! packadd vim-mucomplete
        silent! packadd ultisnips
    endif
    if l:comptype !=# 'coc' && !exists('g:did_coc_loaded')
        silent! packadd ale
        silent! packadd vim-gitgutter
    endif
endfunction

" ====================================================
" Filename:    plugin/pack.vim
" Description: Interface with packages and package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-24 12:53:26 CST
" ====================================================
if exists('g:loaded_plugin_pack') || exists('g:no_load_plugins') | finish | endif
let g:loaded_plugin_pack = 1

let g:package_manager = 'vim-packager'

let g:package_defer_time = 300

" Call minpac or minpac wrappers
command! -bang PackUpdate call plugins#init() | call pack#update({'force_hooks': <bang>0})
command!       PackClean  call plugins#init() | call pack#clean()
command!       PackStatus call plugins#init() | call pack#status()

augroup deferred_pack_load
    autocmd!
    autocmd VimEnter * ++once call timer_start(g:package_defer_time, { -> s:deferred_load() })
    autocmd FileType * ++once call timer_start(g:package_defer_time, { -> s:deferred_load_filetype() })
augroup END

" Load packages that are safe to defer
function! s:deferred_load() abort
    silent! packadd targets.vim
    silent! packadd tcomment_vim
    silent! packadd asyncrun.vim
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
    endif
    if l:comptype !=# 'coc'
        silent! packadd ale
        silent! packadd vim-gitgutter
    endif
endfunction

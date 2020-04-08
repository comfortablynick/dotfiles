" ====================================================
" Filename:    plugin/pack.vim
" Description: Interface with packages and package manager
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_plugin_pack' | if exists(s:guard) | finish | endif
let {s:guard} = 1

let g:package_manager = 'vim-packager'

let g:package_defer_time = 300

" Call minpac or minpac wrappers
command!       PackInstall call plugins#init() | call packager#install()
command! -bang PackUpdate  call plugins#init() | call packager#update({'force_hooks': '<bang>'})
command!       PackClean   call plugins#init() | call packager#clean()
command!       PackStatus  call plugins#init() | call packager#status()

augroup deferred_pack_load
    autocmd!
    autocmd VimEnter * ++once call timer_start(g:package_defer_time, { -> s:deferred_load() })
    autocmd FileType * call timer_start(g:package_defer_time, { -> s:deferred_load_filetype() })
augroup END

" Load packages that are safe to defer
function! s:deferred_load() abort
    silent! packadd targets.vim
    silent! packadd tcomment_vim
    silent! packadd vim-unimpaired
    silent! packadd clever-f.vim
    silent! packadd vim-sneak
    silent! packadd nvim-miniyank
    silent! packadd vim-tmux-navigator
    silent! packadd better-vim-tmux-resizer
    silent! packadd tig-explorer.vim

    if $MOSH_CONNECTION != 1
        silent! packadd vim-devicons
    endif

    " Load local vimrc if env var
    call localrc#load_from_env()
endfunction

function! s:deferred_load_filetype() abort
    let l:comptype = completion#get_type(&filetype)
    if l:comptype !=# 'coc' && !exists('g:did_coc_loaded')
        silent! packadd ale
        silent! packadd vim-gitgutter
    endif
endfunction

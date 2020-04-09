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
    packadd targets.vim
    packadd tcomment_vim
    packadd vim-unimpaired
    packadd clever-f.vim
    packadd vim-sneak
    packadd nvim-miniyank
    packadd vim-tmux-navigator
    packadd better-vim-tmux-resizer
    packadd tig-explorer.vim

    if $MOSH_CONNECTION != 1
        packadd vim-devicons
    endif

    " Load local vimrc if env var
    call localrc#load_from_env()
endfunction

function! s:deferred_load_filetype() abort
    let l:comptype = completion#get_type(&filetype)
    if l:comptype !=# 'coc' && !exists('g:did_coc_loaded')
        packadd ale
        packadd vim-gitgutter
    endif
endfunction

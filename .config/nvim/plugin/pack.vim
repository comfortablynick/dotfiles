let g:package_manager = 'vim-packager'

let g:package_defer_time = 300

" Package management
command       PackInstall call plugins#init() | call packager#install()
command -bang PackUpdate  call plugins#init() | call packager#update({'force_hooks': '<bang>'})
command       PackClean   call plugins#init() | call packager#clean()
command       PackStatus  call plugins#init() | call packager#status()

augroup plugin_pack
    autocmd!
    autocmd VimEnter * ++once call timer_start(g:package_defer_time, {-> s:deferred_load()})
augroup END

" Load packages that are safe to defer
function! s:deferred_load()
    let l:packs = [
        \ 'fzf',
        \ 'fzf.vim',
        \ 'targets.vim',
        \ 'vim-exchange',
        \ 'tcomment_vim',
        \ 'vim-unimpaired',
        \ 'vim-tmux-navigator',
        \ 'vim-sandwich',
        \ 'vim-smoothie',
        \ 'vim-repeat',
        \ 'vim-eunuch',
        \ 'vim-clap',
        \ 'vim-snippets',
        \ 'vista.vim',
        \ 'vim-floaterm',
        \ 'vim-picker',
        \ 'vim-easy-align',
        \ 'asynctasks.vim',
        \ 'ultisnips',
        \ 'vim-fugitive',
        \ ]

    if has('nvim')
        let l:packs += [
            \ 'nvim-miniyank',
            \ 'FixCursorHold.nvim',
            \ ]
    endif

    for l:pack in l:packs
        exe 'packadd' l:pack
    endfor
endfunction

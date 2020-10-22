let g:package_manager = 'vim-packager'

let g:package_defer_time = 300

" Package management
if get(g:, 'use_packer', 0)
    command! PackerInstall packadd packer.nvim | lua require('plugins').install()
    command! PackerUpdate  packadd packer.nvim | lua require('plugins').update()
    command! PackerSync    packadd packer.nvim | lua require('plugins').sync()
    command! PackerClean   packadd packer.nvim | lua require('plugins').clean()
    command! PackerCompile packadd packer.nvim | lua require('plugins').compile()
else
    command!       PackInstall call plugins#init() | call packager#install()
    command! -bang PackUpdate  call plugins#init() | call packager#update({'force_hooks': '<bang>'})
    command!       PackClean   call plugins#init() | call packager#clean()
    command!       PackStatus  call plugins#init() | call packager#status()
endif

augroup plugin_pack
    autocmd!
    autocmd VimEnter * ++once call timer_start(g:package_defer_time, { -> s:deferred_load() })
augroup END

" Load packages that are safe to defer
function! s:deferred_load() abort
    packadd fzf
    packadd fzf.vim
    packadd targets.vim
    packadd vim-exchange
    " packadd vim-commentary
    packadd tcomment_vim
    packadd vim-unimpaired
    packadd clever-f.vim
    packadd vim-sneak
    packadd vim-tmux-navigator
    packadd better-vim-tmux-resizer
    packadd tig-explorer.vim
    packadd vim-sandwich
    packadd vim-smoothie
    packadd vim-repeat
    packadd vim-eunuch
    packadd vim-clap
    packadd vim-snippets
    packadd vista.vim
    packadd vim-bbye
    packadd vim-floaterm
    packadd vim-picker
    packadd vim-devicons
    packadd vim-lion

    if has('nvim')
        " Seems to have issue on vim
        packadd nvim-miniyank
        packadd plenary.nvim
    endif

    packadd vim-fugitive
    call FugitiveDetect(expand('%:p'))

    " Load local vimrc if env var
    call localrc#load_from_env()
endfunction

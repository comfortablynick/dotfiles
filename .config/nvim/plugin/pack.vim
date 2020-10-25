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
function! s:deferred_load()
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
    " packadd tig-explorer.vim
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

" Plugins {{{1
" Packager setup {{{2
let g:packager_path = expand('$XDG_DATA_HOME/nvim/site')..'/pack/packager-test'
call plugpackager#begin({
    \ 'dir': g:packager_path,
    \ 'default_plugin_type': 'opt',
    \ 'jobs': 0,
    \ })

" Plug 'comfortablynick/plugpackager.vim'
Plug 'iberianpig/tig-explorer.vim', {'on': ['Tig', 'TigStatus']}
" General {{{2
Plug 'chrisbra/Colorizer'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
Plug 'moll/vim-bbye'
Plug 'psliwka/vim-smoothie'

" Linters/formatters/runners {{{2
Plug 'dense-analysis/ale'
Plug 'sbdchd/neoformat'
Plug 'psf/black',                  {'branch': 'stable'}
Plug 'skywind3000/asyncrun.vim',   {'on': ['AsyncRun']}
Plug 'skywind3000/asynctasks.vim',
    \ {
    \   'do': 'ln -sf $(pwd)/bin/asynctask ~/.local/bin',
    \   'on': ['AsyncTask'],
    \ }
Plug 'kkoomen/vim-doge'

" Initialize plugins {{{2
call plugpackager#end()

" vim:fdl=1:

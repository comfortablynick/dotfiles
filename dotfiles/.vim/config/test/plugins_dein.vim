
" Dein init {{{
set nocompatible
filetype plugin indent off
syntax off

if has('vim_starting')
    exec "set runtimepath+=".expand("$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim/")
endif

" Install Dein if needed
if !filereadable(expand('$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim/README.md'))
  echo "Installing Dein..."
  echo ""
  silent !mkdir -p $XDG_DATA_HOME/dein
  silent !git clone https://github.com/Shougo/dein.vim $XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim/
  silent !cd $XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim/
  silent !sh ./installer.sh $XDG_DATA_HOME/dein
  echo "Dein install completed."
endif
" }}}
" Plugins {{{
if dein#load_state(expand('$XDG_DATA_HOME/dein'))
    call dein#begin(expand('$XDG_DATA_HOME/dein'))

    " Let Dein manage itself
    call dein#add(expand('$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim'))


    " Editor features
    call dein#add('airblade/vim-gitgutter')
    call dein#add('scrooloose/nerdtree', {'on_cmd': 'NERDTreeToggle'})
    call dein#add('severin-lemaignan/vim-minimap', {'on_cmd': 'Minimap'})
    call dein#add('ryanoasis/vim-devicons', {'if': '$NERD_FONTS != 0'})

    " Color themes
    call dein#add('morhetz/gruvbox', {'merged': 0})
    call dein#add('arcticicestudio/nord-vim', {'merged': 0})
    call dein#add('NLKNguyen/papercolor-theme', {'merged': 0})
    call dein#add('nightsense/snow', {'merged': 0})
    
    " Syntax highlighting
    call dein#add('HerringtonDarkholme/yats', {'on_ft': 'typescript'})
    call dein#add('gabrielelana/vim-markdown', {'on_ft': 'markdown'})
    call dein#add('Soares/fish.vim', {'on_ft': 'fish'})

    " Formatting
    call dein#add('ambv/black', {'on_ft': 'python'})

    " Git
    call dein#add('junegunn/gv.vim')
    call dein#add('tpope/vim-fugitive')

    " Executing
    call dein#add('skywind3000/asyncrun.vim', {'lazy': 1})

    " call dein#add('Shougo/deoplete.nvim', {'build': 'vim -s +"call dein#remote_plugins()"'})

    call dein#end()
    call dein#save_state()
endif

if dein#check_install() 
	call dein#install()
endif

filetype plugin indent on
syntax enable
" }}}

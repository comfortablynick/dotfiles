# Defined in /tmp/fish.36Afth/_build:vim.fish @ line 2
function _build:vim --description 'build vim from source' --argument src_dir
	if ! test -d $src_dir
        echo "Source dir not found at $src_dir! Aborting..."
        return 1
    end
    set -l orig_pwd (pwd)
    echo "Building Vim from local source repo at $src_dir"
    cd $src_dir

    # Build Vim
    ./configure --with-features=huge \
        --enable-multibyte \
	    --enable-rubyinterp=yes \
	    --enable-python3interp=yes \
	    --with-python3-config-dir=/usr/lib/python3.5/config \
	    --enable-perlinterp=yes \
	    --enable-luainterp=yes \
        --enable-cscope \
	    --prefix=/usr/local

    # make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
    make VIMRUNTIMEDIR=./bin

    # Return to original dir
    cd $orig_pwd
end

# Defined in /tmp/fish.kaUuSS/_build:vim.fish @ line 2
function _build:vim --description 'build vim from source' --argument src_dir
	if ! test -d $src_dir
        echo "Source dir not found at $src_dir! Aborting..."
        return 1
    end
    # Check for venv; deactivate so we don't interfere with vim python
    set -l venv "$VIRTUAL_ENV"
    if test -n "$venv"
        echo "Deactivating virtualenv ..."
        deactivate
    end
    set -l orig_pwd (pwd)
    echo "Building Vim from local source repo at $src_dir"
    cd $src_dir

    # Build Vim
    set -l py3_dir
    switch $hostname
        case "io"
            set py3_dir /usr/local/lib/python3.7/config-3.7m-x86_64-linux-gnu
        case "*"
            echo "Need to set python3 config dir for this host."
            return 1
    end
    ./configure --with-features=huge \
        --enable-multibyte \
	    --enable-rubyinterp=yes \
	    --enable-python3interp=yes \
	    --with-python3-config-dir=$py3_dir \
	    --enable-perlinterp=yes \
	    --enable-luainterp=yes \
        --enable-cscope \
	    --prefix=/usr/local

    make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
    sudo make install

    # Return to original dir
    cd $orig_pwd
    if test -n "$venv"
        echo "Reactivating venv..."
        source "$venv/bin/activate.fish"
    end
end

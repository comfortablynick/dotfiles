# Defined in /tmp/fish.IZ98l4/_build:vim.fish @ line 2
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
    # set -l py3_cmd "/usr/bin/python3"
    # set -l py3_dir ("$py3_cmd-config" --configdir)
    # echo "Building with python3 config dir: $py3_dir"

    ./configure --with-features=huge \
        --enable-fail-if-missing \
        --enable-multibyte \
        --enable-rubyinterp=yes \
        --enable-python3interp=yes \
        --enable-perlinterp=yes \
        --enable-luainterp=yes \
        --enable-cscope \
        --prefix=$HOME/.local

    # make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
    make install

    # Return to original dir
    cd $orig_pwd
    if test -n "$venv"
        echo "Reactivating venv..."
        source "$venv/bin/activate.fish"
    end
end

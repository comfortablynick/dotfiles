# Defined in /tmp/fish.cYLFvq/_build:neovim.fish @ line 2
function _build:neovim --description 'build neovim from source' --argument src_dir
	if ! test -d $src_dir
        echo "Source dir not found at $src_dir! Aborting..."
        return 1
    end
    set -l orig_pwd (pwd)
    echo "Building Neovim from local source repo at $src_dir"
    cd $src_dir

    # Build bundled deps
    test -d .deps; and rm -rf .deps
    mkdir .deps; cd .deps
    begin
        cmake ../third-party;
        and make;
        or return 1
    end;

    # Build Neovim
    cd ..
    test -d build && rm -rf build
    mkdir build; cd build
    begin
        cmake ..;
        and make;
        and sudo make install;
        or return 1
    end
    # Return to original dir
    cd $orig_pwd
end

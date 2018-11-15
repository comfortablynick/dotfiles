# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.BNJxwr/build_fish.fish @ line 2
function build_fish --description 'Build fish shell from source'
	set -l fish_repo "$HOME/src/fish-shell"
  if test -d $fish_repo
    set -l orig_pwd (pwd)
    echo "Building fish from local source repo at $fish_repo"
    cd $fish_repo
    # Add git pull here?
    test -d build && rm -rf build
    mkdir build; cd build
    cmake ..
    make
    echo "Installing ..."
    command sudo fish -c "make install"
    # Return to original dir
    cd $orig_pwd
  else
    echo "Source repo not found at $fish_repo! Aborting ..."
  end
end

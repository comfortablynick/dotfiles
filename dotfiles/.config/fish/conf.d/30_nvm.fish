# Install nvm if not already

if test -z (type -f node 2>/dev/null)
    # nvm
    if not test -d "$HOME/.nvm"
        echo "nvm not found. Cloning nvm..."
        command git clone https://github.com/creationix/nvm.git "$HOME/.nvm"
        cd "$HOME/.nvm"
        command git checkout (command git describe --abbrev=0 --tags --match "v[0-9]*" (git rev-list --tags --max-count=1))
    end

    # Put node binaries in PATH if not already
    if test -d "$node_bin_path"
            set -p PATH "$node_bin_path"
    else
        set -l node_latest (ls -a "$HOME/.nvm/versions/node" | string match -r 'v.*' | sort -V | tail -n1)
        if test -n "$node_latest"
            set -p PATH "$HOME/.nvm/versions/node/$node_latest/bin"
        end
    end
end

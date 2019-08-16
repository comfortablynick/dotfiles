# Install nvm if not already

# if [ -z "$(command -v node 2>/dev/null)" ]; then
#     if [ ! -d "$HOME/.nvm" ]; then
#         echo "nvm not found. Cloning nvm..."
#         command git clone https://github.com/creationix/nvm.git "$HOME/.nvm"
#         cd "$HOME/.nvm"
#         command git checkout $(command git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
#     fi
#     # Put node binaries in PATH if not already
#     if [ -d "$node_bin_path" ]; then
#         export PATH="$node_bin_path:$PATH"
#     else
#         if [ -d "$HOME/.nvm/versions/node" ]; then
#             node_latest="$(ls -a "$HOME/.nvm/versions/node" | sort -V | tail -n1)"
#             if [ -n "$node_latest" ]; then
#                  export PATH="$HOME/.nvm/versions/node/$node_latest/bin:$PATH"
#             fi
#         fi
#     fi
# fi

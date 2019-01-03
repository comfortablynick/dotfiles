# Check env.toml checksum for changes

env_file="$HOME/.env_toml_sha_bash"
env_sha=$(sha1 "$HOME/dotfiles/dotfiles/env.toml" | cut -d' ' -f1)

if [ ! -f "$env_file" ] || [ "$env_sha" != "$(< $env_file)" ]; then
    echo "Changes made to env.toml since bash last started."
    parse_env.py -b $HOME/dotfiles/dotfiles/env.toml
    echo "$env_sha" > $env_file
fi

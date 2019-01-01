# Check env.toml checksum for changes
return
env_file="$HOME/.env_toml_sha"
env_sha=$(sha1sum "$HOME/dotfiles/dotfiles/env.toml" | cut -d' ' -f1)

if [ ! -f "$env_file" ] || [ "$env_sha" != "$(<env_file)" ]; then
    echo "Changes made to env.toml."
    parse_env.py $HOME/dotfiles/dotfiles/env.toml -b
    echo "$env_sha" > "$env_file"
fi

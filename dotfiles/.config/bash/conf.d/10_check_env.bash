# Check env.toml checksum for changes

env_file="$HOME/.env_toml_sha_bash"
sha_cmd=$(command -v sha1sum || command -v gsha1sum)
env_sha=$(eval "$sha_cmd" "$HOME/dotfiles/dotfiles/env.toml" | cut -d' ' -f1)

if [ ! -f "$env_file" ] || [ "$env_sha" != "$(<"$env_file")" ]; then
    echo "Changes made to env.toml since bash last started."
    py_path="$($HOME/.asdf/bin/asdf which python)"
    "$py_path" "$HOME/.config/shell/functions/parse_env" -b "$HOME/dotfiles/dotfiles/env.toml"
    echo "$env_sha" >"$env_file"
fi

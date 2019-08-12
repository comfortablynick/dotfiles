# Check env.toml checksum for changes
# Python must have tomlkit installed

env_file="$HOME/.env_toml_sha_zsh"
sha_cmd=$(command -v sha1sum || command -v gsha1sum)
env_sha="$(eval $sha_cmd $HOME/dotfiles/dotfiles/env.toml | cut -d' ' -f1)"

if [[ ! -f $env_file ]] || [[ $env_sha != $(<$env_file) ]]; then
    echo "Changes made to env.toml since zsh last started."
    python3 "$HOME/.config/shell/functions/parse_env" -z "$HOME/dotfiles/dotfiles/env.toml"
    echo "$env_sha" >"$env_file"
fi

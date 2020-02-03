# Check env.toml checksum for changes
# Python must have tomlkit installed
env_file="$HOME/.env_toml_sha_$CURRENT_SHELL"
sha_cmd="$(command -v sha1sum || command -v gsha1sum)"
env_sha="$(eval "$sha_cmd" "$HOME/dotfiles/dotfiles/env.toml" | cut -d' ' -f1)"

if [ ! -f "$env_file" ] || [ "$env_sha" != "$(cat "$env_file")" ]; then
    echo "Changes made to env.toml since $CURRENT_SHELL last started."
    "$HOME/.asdf/bin/asdf" exec python3 "$HOME/bin/parse_env" "$HOME/dotfiles/dotfiles/env.toml" "$XDG_CONFIG_HOME/$CURRENT_SHELL/conf.d/01_env.$CURRENT_SHELL"
    echo "$env_sha" >"$env_file"
fi

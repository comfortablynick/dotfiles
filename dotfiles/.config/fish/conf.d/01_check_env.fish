# Check env.toml file for changes compared with previous checksum
if status is-interactive
    set -l env_sha (string split ' ' (sha1 "$HOME/dotfiles/dotfiles/env.toml"))[1]

    if test "$env_sha" = "$env_toml_sha"
        # No changes; we're good!
        exit 0
    end

    # Run parsing script to update env.fish
    echo "env.toml has changed!"
    set -l py_path ($HOME/.asdf/bin/asdf which python)
    set -l parse_env "$HOME/.config/shell/functions/parse_env"
    if test -e "$py_path"
        echo "$py_path $parse_env $HOME/dotfiles/dotfiles/env.toml -f" | source

        # Set variable to reload file on shell init
        set -U env_file_sourced 0

        # Update checksum
        set -U env_toml_sha "$env_sha"
    else
        echo "01_check_env.fish error: no asdf python interpreter found. Aborting!"
    end
end

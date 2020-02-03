# Check env.toml file for changes compared with previous checksum
if status is-interactive
    set -l env_sha (string split ' ' ($HOME/bin/sha1 "$HOME/dotfiles/dotfiles/env.toml"))[1]

    if test "$env_sha" = "$env_toml_sha"
        # No changes; we're good!
        exit 0
    end

    # Run parsing script to update env.fish
    echo "env.toml has changed!"
    set -l py_path ($HOME/.asdf/bin/asdf which python)
    set -l parse_env "$HOME/bin/parse_env"
    set -l toml_file $HOME/dotfiles/dotfiles/env.toml
    set -l env_file "$HOME/.config/fish/env.fish"
    if test -e "$py_path"
        echo "$py_path $parse_env $toml_file $env_file -s fish" | source

        # Set variable to reload file on shell init
        set -U env_file_sourced 0

        # Update checksum
        set -U env_toml_sha "$env_sha"
    else
        echo "01_check_env.fish error: no asdf python interpreter found. Aborting!"
    end
end

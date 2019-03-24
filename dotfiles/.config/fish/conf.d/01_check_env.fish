# Check env.toml file for changes compared with previous checksum
if status is-interactive
    set -l env_sha (string split ' ' (sha1 "$HOME/dotfiles/dotfiles/env.toml"))[1]

    if test "$env_sha" = "$env_toml_sha"
        # No changes; we're good!
        exit 0
    end

    # Run parsing script to update env.fish
    echo "env.toml has changed!"
    parse_env.py "$HOME/dotfiles/dotfiles/env.toml" -f

    # Set variable to reload file on shell init
    set -U env_file_sourced 0

    # Update checksum
    set -U env_toml_sha "$env_sha"
end

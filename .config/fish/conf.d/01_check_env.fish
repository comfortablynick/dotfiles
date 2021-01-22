# Check env.toml file for changes compared with previous checksum
set -gx CURRENT_SHELL fish
set -l dotdir $HOME/dotfiles

if status is-interactive; and test -d "$dotdir"
    set -l env_sha (string split ' ' ($HOME/bin/sha1 "$dotdir/env.toml"))[1]
    if test "$env_sha" = "$env_toml_sha"
        exit 0 # No changes; we're good!
    end
    # Run parsing script to update env.fish
    echo "env.toml has changed!"
    # set -l py_paths ($HOME/.asdf/bin/asdf which python 2>/dev/null) python3
    # set -l py_paths python3
    # test -x $HOME/.asdf/bin/asdf; and set -p py_paths ($HOME/.asdf/bin/asdf which python)
    # set -l py_path
    # for path in $py_paths
    #     if type -qf $path
    #         set py_path $path
    #         break
    #     end
    # end
    set -l py_path (which python3)
    set -l parse_env $HOME/bin/parse_env
    set -l toml_file $dotdir/env.toml
    set -l env_file $HOME/.config/fish/env.fish
    if test -n "$py_path"
        echo "$py_path $parse_env $toml_file $env_file -s fish" | source
        set -U env_file_sourced 0
        set -U env_toml_sha "$env_sha"
    else
        echo "01_check_env.fish error: no python interpreter found. Aborting!"
    end
end

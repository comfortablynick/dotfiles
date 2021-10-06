# Check env.toml file for changes compared with previous checksum
set -gx CURRENT_SHELL fish

if status is-interactive
    set -l toml_file $HOME/env.toml
    set -l env_sha (string split ' ' ($HOME/bin/sha1 $toml_file))[1]
    if test "$env_sha" = "$env_toml_sha"
        exit 0 # No changes; we're good!
    end
    # Run parsing script to update env.fish
    echo "env.toml has changed!"
    set -l py_path (which python3)
    set -l asdf_versions_file $HOME/.tool-versions

    # Use asdf global python if available
    if test -e $asdf_versions_file
        set -l asdf_py_ver (string match -r -- '^python\s(3.*)$' <$asdf_versions_file)[2]
        set -l asdf_py_path "$HOME/.asdf/installs/python/$asdf_py_ver/bin/python3"
        test -x $asdf_py_path; and set py_path $asdf_py_path
    end

    set -l parse_env $HOME/bin/parse_env
    set -l env_file $HOME/.config/fish/env.fish
    if test -n "$py_path"
        $py_path $parse_env $toml_file $env_file -s fish
        set -U env_file_sourced 0
        set -U env_toml_sha "$env_sha"
    else
        set_color $fish_color_error
        echo "01_check_env.fish error: no python interpreter found. Aborting!" 1>&2
        set_color normal
    end
end

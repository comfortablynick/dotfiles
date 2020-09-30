set -l direnv_versions $HOME/.tool-versions

if status is-interactive; and type -q asdf; and test -e "$direnv_versions"
    set -g asdf_direnv_version (string match "direnv*" < "$direnv_versions" | string split ' ')[2]
    set -l direnv_path "$HOME/.asdf/installs/direnv/$asdf_direnv_version/bin/direnv"
    if test -x "$direnv_path"
        echo "
function __direnv_export_eval --on-event fish_prompt
    $direnv_path export fish | source
end
        " | source
    end
end

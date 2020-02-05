if type -q asdf
    # asdf exec direnv hook fish | source
    set -g asdf_direnv_version (string match "direnv*" < $HOME/.tool-versions | string split ' ')[2]
    function __direnv_export_eval --on-event fish_prompt;
            "$HOME/.asdf/installs/direnv/$asdf_direnv_version/bin/direnv" export fish | source;
    end
end

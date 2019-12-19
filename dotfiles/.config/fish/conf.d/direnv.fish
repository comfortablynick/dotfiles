if type -q direnv
    function __direnv_export_eval -d "Local .envrc hook" --on-event fish_preexec

        status --is-command-substitution
        and return
        command direnv export fish | source
    end
end

if type -q asdf
    # function __direnv_export_eval -d "Local .envrc hook" --on-event fish_preexec
    #
    #     status --is-command-substitution
    #     and return
    #     asdf exec direnv hook fish | source
        asdf exec direnv export fish | source
    # end
end

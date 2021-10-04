if status is-interactive
    if direnv &>/dev/null
        direnv hook fish | source
    else
        if asdf &>/dev/null
            asdf exec direnv hook fish | source
        end
    end
end

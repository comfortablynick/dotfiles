function _pyenv_virtualenv_hook --on-event fish_prompt
    set -l ret $status
    if test -n "$VIRTUAL_ENV"
        pyenv activate --quiet
        or pyenv deactivate --quiet
        or true
    else
        pyenv activate --quiet
        or true
    end
    return $ret
end

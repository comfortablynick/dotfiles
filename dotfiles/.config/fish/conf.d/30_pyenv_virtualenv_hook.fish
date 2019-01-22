# test "$OSTYPE" != "linux*"
# and exit
function _pyenv_virtualenv_hook --on-event fish_prompt
    set -l ret $status
    if test -n "$VIRTUAL_ENV"
        pyenv activate --quiet
        or pyenv deactivate --quiet
    else
        pyenv activate --quiet
    end
    return $ret
end

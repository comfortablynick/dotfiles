function aurr -d 'Pick packages to remove using fzf and aur helper'
    if not set -q aur_helper
        set -f aur_helper (command -v paru; or command -v yay)
    end
    if test -z "$aur_helper"
        echo 'error: cannot find paru or yay. Set $aur_helper to specify binary'
        return 1
    end
    set pkg ($aur_helper --color=always -e -Qq | _fzf_wrapper -q "$argv" --multi --tiebreak=length --preview="$aur_helper --color=always -Qli {1}")
    if test -n "$pkg"
        echo "Removing $pkg..."
        $aur_helper -R --cascade --recursive $pkg
    end
end

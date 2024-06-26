function aurr -d 'Pick packages to remove using fzf and aur helper'
    set pkg (_aur_helper --color=always -e -Qq | _fzf_wrapper -q "$argv" --multi --tiebreak=length --preview="_aur_helper --color=always -Qli {1}")
    if test -n $pkg
        echo "Removing $pkg..."
        _aur_helper -R --cascade --recursive $pkg
    end
end

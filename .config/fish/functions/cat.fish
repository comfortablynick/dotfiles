# Defined in /tmp/fish.vDpAft/cat.fish @ line 2
function cat --description 'alias cat for best cat option installed'
    set -l cats bat ccat gcat
    set -l found
    for cat in $cats
        if type -qf $cat
            set found $cat
            break
        end
    end
    $found $argv
end

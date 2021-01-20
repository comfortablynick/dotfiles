function cat --description 'alias cat for best cat option installed'
    set -l cats bat ccat gcat cat
    set -l found
    for cat in $cats
        if type -qf $cat
            set found $cat
            break
        end
    end
    eval command $found $argv
end

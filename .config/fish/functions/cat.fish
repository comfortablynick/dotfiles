function cat --description 'alias cat for best cat option installed'
    for cat in bat ccat gcat cat
        if command -q $cat
            command $cat $argv
            return
        end
    end
end

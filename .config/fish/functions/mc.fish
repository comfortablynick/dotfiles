function mc --description 'Create directory, then cd to it'
    if command mkdir $argv
        switch $argv[(count $argv)]
            case '-*'

            case '*'
                cd $argv[(count $argv)]
                return
        end
    end
end

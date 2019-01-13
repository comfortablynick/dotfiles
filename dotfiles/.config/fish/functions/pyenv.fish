# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.b8ORbM/pyenv.fish @ line 2
function pyenv
	set command $argv[1]
    set -e argv[1]

    switch "$command"
        case activate deactivate rehash shell
            source (command pyenv "sh-$command" $argv|psub)
        case '*'
            command pyenv "$command" $argv
            # command pyenv $command $argv
    end
end

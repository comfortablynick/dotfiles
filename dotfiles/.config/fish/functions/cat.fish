# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.uZucqZ/cat.fish @ line 2
function cat --description 'wrapper for cat'
	if type -q bat
        bat $argv
    else if type -q ccat
        ccat $argv
    else
        # cat probably can't take the args
        # so let's strip them for now
        command cat
    end
end

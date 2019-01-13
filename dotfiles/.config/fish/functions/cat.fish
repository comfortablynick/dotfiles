# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.o3v2T0/cat.fish @ line 2
function cat --description 'wrapper for cat'
	if type -q bat
        bat $argv
    else if type -q ccat
        ccat $argv
    else
        command cat $argv
    end
end

# Defined in /tmp/fish.IoMp2e/cat.fish @ line 2
function cat --description 'wrapper for cat'
	if type -q bat
        bat $argv
    else if type -q ccat
        ccat $argv
    else
        # cat probably can't take the args
        # so let's strip them for now
        cat
    end
end

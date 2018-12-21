# Defined in /tmp/fish.irv1gH/sha1sum.fish @ line 1
function sha1sum --description 'wrapper for sha1sum and gsha1sum'
	if type -qf sha1sum
        command sha1sum $argv
    else
        command gsha1sum $argv
    end
end

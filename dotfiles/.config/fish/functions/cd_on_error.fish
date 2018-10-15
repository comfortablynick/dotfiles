# Defined in - @ line 2
function cd_on_error --description 'Try to cd when command not found.' --on-event fish_command_not_found
	if test -d $argv[1]
        echo "$argv[1] is a directory! Attempting cd ... "
        cd $argv[1]
    else
        return
    end
end

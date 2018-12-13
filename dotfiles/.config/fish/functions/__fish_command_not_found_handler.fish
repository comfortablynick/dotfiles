# Defined in /tmp/fish.5ZKpRJ/__fish_command_not_found_handler.fish @ line 2
function __fish_command_not_found_handler --description 'replace system handler' --on-event fish_command_not_found
	if test -d "$argv[1]"
        echo "cd $argv[1]"
        cd "$argv[1]"
        return 0
    else
        echo "Command not found: $argv[1]"
        return 1
    end
end

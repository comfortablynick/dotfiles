# Defined in /tmp/fish.8KXOKu/__fish_prog_using_command.fish @ line 2
function __fish_prog_using_command --description 'completion helper function'
	set -l cmd (commandline -opc)
    if test (count $cmd) -gt 1
        if test $argv[1] = $cmd[2]
            return 0
        end
    end
    return 1
end

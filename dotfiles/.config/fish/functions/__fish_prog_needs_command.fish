# Defined in /tmp/fish.K1gGwq/__fish_prog_needs_command.fish @ line 2
function __fish_prog_needs_command --description 'completion helper function'
	set -l cmd (commandline -opc)
    if test (count $cmd) -eq 1
        return 0
    end
    return 1
end

#!/usr/bin/env fish
function __fish_prog_needs_command
	set -l cmd (commandline -opc)
	if test (count $cmd) -eq 1
		return 0
	end
	return 1
end

function __fish_prog_using_command
	set -l cmd (commandline -opc)
	if test (count $cmd) -gt 1
		if test $argv[1] = $cmd[2]
			return 0
		end
	end
	return 1
end

complete -f -c rod -n '__fish_prog_needs_command' -a init -d "load all plugins"
complete -f -c rod -n '__fish_prog_needs_command' -a plugin -d "add a plugin"
complete -f -c rod -n '__fish_prog_needs_command' -a list -d "list plugins"
complete -f -c rod -n '__fish_prog_needs_command' -a install -d "install all plugins"

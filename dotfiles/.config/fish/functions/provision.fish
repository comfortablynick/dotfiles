# Defined in /tmp/fish.wC0tXM/provision.fish @ line 1
function provision --description 'set up system software packages'
	python "$XDG_CONFIG_HOME/shell/provision/provision" $argv
end

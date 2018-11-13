# Defined in /tmp/fish.guVIVO/chpwd.fish @ line 2
function chpwd --description 'list directory contents on change of PWD' --on-variable PWD
	status --is-command-substitution; and return
  ls -a
end

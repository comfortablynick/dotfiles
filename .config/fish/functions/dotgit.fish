# Defined in - @ line 2
function dotgit --description 'Alias for dotfile git command' --w 'git'
	git -C ~/dotfiles $argv
end

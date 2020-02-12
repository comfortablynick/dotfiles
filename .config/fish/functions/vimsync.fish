# Defined in /tmp/fish.h4rL9V/vimsync.fish @ line 2
function vimsync --description 'Download plugins for Vim and Neovim and execute any associated actions defined in vimrc'
	python "$HOME/git/python/shell/vimsync.py" $argv
end

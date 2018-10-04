function dotsync --description 'Sync git dotfile repo'
	echo "Syncing dotfile repo. Dotdrop.sh needs to be executed from bash."
dotgit pull
and dotgit add -A
and dotgit commit
and dotgit push
end

# Defined in - @ line 2
function dotsync --description 'Sync git dotfile repo'
	echo "Syncing dotfile repo. dotdrop.sh needs to be executed from bash."
    dotgit pull
    and dotgit submodule update --init --recursive
    and dotgit submodule update --remote dotdrop
    and dotgit add -A
    and dotgit commit
    and dotgit push
end

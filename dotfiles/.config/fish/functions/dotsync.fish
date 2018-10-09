# Defined in - @ line 2
function dotsync --description 'Sync git dotfile repo'
	echo "Syncing dotfile repo ... "
    dotgit pull
    and dotgit add -A
    and dotgit commit
    and dotgit push
    echo "Running dotdrop install ... "
    and dotdrop install
end

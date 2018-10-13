# Defined in - @ line 2
function dotsync --description 'Sync git dotfile repo'
	echo "Updating dotdrop submodule ... "
    dotgit submodule foreach --recursive git pull origin master
    echo "Syncing dotfile repo ... "
    and dotgit pull
    and dotgit add -A
    and dotgit commit
    and dotgit push
    echo "Running dotdrop install ... "
    and dotdrop install
end

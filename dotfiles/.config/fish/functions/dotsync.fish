# Defined in /tmp/fish.3PvY0v/dotsync.fish @ line 2
function dotsync --description 'Sync git dotfile repo'
	set -q LS_AFTER_CD
    and set LS_AFTER_CD 0

    echo "Updating dotdrop submodule ... "
    dotgit submodule foreach --recursive git pull origin master
    echo "Syncing dotfile repo ... "
    and dotgit pull
    and dotgit add -A
    and dotgit commit
    and dotgit push
    echo "Running dotdrop install ... "
    and dotdrop install

    set -q LS_AFTER_CD
    and set LS_AFTER_CD 1
end

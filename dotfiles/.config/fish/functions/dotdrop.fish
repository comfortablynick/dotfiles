# Defined in /tmp/fish.1NGrwl/dotdrop.fish @ line 2
function dotdrop --description 'Execute dotdrop dotfile system functions.'
	set -q LS_AFTER_CD
    and set LS_AFTER_CD 0

	set -l opwd (pwd)
    set -l dotd "$HOME/dotfiles/"
    cd $dotd
    # init/update the submodule
    git submodule update --init --recursive
    git submodule update --remote dotdrop
    # execute dotdrop in Python
    env PYTHONPATH=dotdrop python -m dotdrop.dotdrop $argv
    # go back to original dir
    cd $opwd

    set -q LS_AFTER_CD
    and set LS_AFTER_CD 1
end

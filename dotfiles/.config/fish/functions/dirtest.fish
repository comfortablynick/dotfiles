# Defined in /tmp/fish.iGKaZo/dirtest.fish @ line 2
function dirtest
	test -z "$dirprev"; and return 1
    set -l dirs
    for d in $dirprev
        if test -d $d; and not contains $d $dirs
            set -a dirs $d
        end
    end
    echo $dirs
end

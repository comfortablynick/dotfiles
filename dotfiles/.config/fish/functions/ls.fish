# Defined in - @ line 2
function ls --description 'List contents of directory'
	set -l param --color=auto
    if isatty 1
        set -a param --indicator-style=classify
    end
    if test (uname) = 'Darwin'
        # Use coreutils version which processes $LS_COLORS
        command gls $param $argv
    else
        command ls $param $argv
    end
end

function cd-gitroot --description 'cd to current git root directory'
    argparse h/help -- $argv
    or return 1

    if set -q _flag_h
        echo 'Usage: cd-gitroot [OPTION] [PATH]

Change directory to current git repository root directory.
If PATH is specified, change directory to PATH instead of it.
PATH is treated relative path in git root directory.

Options:
-h, --help    display this help and exit' 1>&2
        return 1
    end

    if not git rev-parse --is-inside-work-tree &>/dev/null
        echo "cd-gitroot: Not in a git repository
Try '-h' or '--help' option for more information." 1>&2
        return 2
    end

    set -l root_path (git rev-parse --show-toplevel)
    set -l relative_path $argv[1]

    if test -z "$relative_path"
        cd -- $root_path
    else
        cd -- $root_path/$relative_path
    end
end

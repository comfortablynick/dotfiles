function edit
    argparse --ignore-unknown f/finder= h/help -- $argv
    or return 1

    if set -q _flag_help
        echo 'Usage: edit [-h/--help] [-f/--finder=FINDER] -- [finder options]

Edit file in $EDITOR using supplied fuzzy finder or a default finder

Optional arguments:

-h, --help      Print this help message and exit
-f, --finder    Override default finder with this executable

Finder options:

If supplying a finder via -f, any arguments after -- will be given to the finder.
'
        return 1
    end

    if test -z "$EDITOR"
        echo -e '$EDITOR is not set'
        return 1
    end

    set -l use_finder

    if set -q _flag_finder
        if type -qf $_flag_finder
            set use_finder $_flag_finder $argv
        else
            echo -e "Finder `$_flag_finder` is not a valid executable."
            return 1
        end
    else
        # Use the first executable fuzzy finder
        for finder in fzy rff fzf sk
            if command -q $finder
                set use_finder $finder
                break
            end
        end
    end

    if test -z "$use_finder"
        echo "Missing fuzzy finder; install fzy, fzf, etc. before running this command"
        return 1
    end

    # eval "$FZY_DEFAULT_COMMAND" | $use_finder | while read -l result
    #     set -a files $result
    # end
    set files (eval "$FZY_DEFAULT_COMMAND" | $use_finder)

    if test -z "$files"
        commandline -f repaint
        return
    end

    commandline -tr "$EDITOR "
    commandline -tr (string escape -- $files | string join ' ')
    commandline -f repaint
    commandline -f execute
end

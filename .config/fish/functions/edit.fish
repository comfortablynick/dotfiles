function edit
    argparse --ignore-unknown f/finder= h/help -- $argv
    or return 1

    set -l help_txt 'Usage: edit [-h/--help] [-f/--finder=FINDER] -- [finder options]'
    set -a help_txt '\n\nEdit file in $EDITOR using supplied fuzzy finder or a default finder'
    set -a help_txt '\n\nOptional arguments:\n'
    set -a help_txt '\n-h, --help\tPrint this help message and exit'
    set -a help_txt '\n-f, --finder\tOverride default finder with this executable'
    set -a help_txt '\n\nFinder options:\n'
    set -a help_txt '\nIf supplying a finder via -f, any arguments after -- will be given to the finder.'
    set -a help_txt '\n'

    if set -q _flag_help
        echo -e $help_txt
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
        set -l fuzzy_finders fzy rff fzf sk
        # Use the first executable fuzzy finder
        for finder in $fuzzy_finders
            if type -qf $finder
                set use_finder $finder
                break
            end
        end
    end

    if test -z "$use_finder"
        echo "Missing fuzzy finder; install fzy, fzf, etc. before running this command"
        return 1
    end
    eval "$FZY_DEFAULT_COMMAND" | $use_finder | while read -l result
        set files $files $result
    end
    if test -z "$files"
        commandline -f repaint
        return
    end
    commandline -r ""

    for file in $files
        commandline -it -- "$EDITOR "
        commandline -it -- (string escape $file)
        commandline -it ' '
    end
    commandline -f execute
end

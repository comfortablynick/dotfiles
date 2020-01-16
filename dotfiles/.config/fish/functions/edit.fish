# Defined in /tmp/fish.KzvhkJ/edit.fish @ line 2
function edit
    set -l fuzzy_finders rff fzy fzf sk
    # Use the first executable fuzzy finder
    for finder in $fuzzy_finders
        if type -qf $finder
            break
        end
    end
    if test -z "$finder"
        echo "Missing fuzzy finder; install fzy, fzf, etc. before running this command"
    end
    eval "$FZY_DEFAULT_COMMAND" | $finder | read file
    if test -z "$file"
        commandline -f repaint
        return
    else
        commandline -t ""
    end

    commandline -it -- "$EDITOR "
    commandline -it -- (string escape $file)
    commandline -f repaint
    commandline -f execute
end

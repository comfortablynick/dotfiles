# Defined in /tmp/fish.FB4Tg0/edit.fish @ line 2
function edit
    eval "$FZY_DEFAULT_COMMAND" | fzy | read file
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

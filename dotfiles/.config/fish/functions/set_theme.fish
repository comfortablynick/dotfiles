# Defined in /tmp/fish.66uS5M/set_theme.fish @ line 2
function set_theme --description 'set local theme file'
	set -l options 's/ssh' 'h/help'
    set -l help_txt 'usage: set_theme NAME [ [--ssh] ]'
    argparse $options -- $argv
    test -z "$argv" && echo $help_txt && return 1
    set -q _flag_help && echo $help_txt && return 0

    set -l file
    if set -q _flag_ssh
        echo "Setting ssh theme"
        set file "$XDG_DATA_HOME/fish/ssh_theme"
    else
        echo "Setting theme"
        set file "$XDG_DATA_HOME/fish/theme"
    end
    echo $argv > "$file"
    and echo 'Reload shell to see changes'
end

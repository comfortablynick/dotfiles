# Defined in /tmp/fish.LwmePr/set_theme.fish @ line 2
function set_theme --description 'set local theme file and reload shell'
	set -l options 's/ssh' 'h/help'
    set -l help_txt 'usage: set_theme NAME [ [--ssh] ]'
    argparse $options -- $argv
    test -z "$argv" && echo $help_txt && return 1

    set -q _flag_help && echo $help_txt && return 0
    if set -q _flag_ssh
        echo "Setting ssh theme"
        # Unset global variable (not needed)
        set -eg FISH_SSH_THEME
        set -Ux FISH_SSH_THEME $argv
    else
        echo "Setting theme"
        set -eg FISH_THEME
        set -Ux FISH_THEME $argv
    end
    echo "Reload shell to see changes"
end

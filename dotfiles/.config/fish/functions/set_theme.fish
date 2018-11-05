# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.bLRXTW/set_theme.fish @ line 2
function set_theme --description 'set local theme file and reload shell' --argument theme_name
    set -l options 's/ssh'
    set -l help_txt 'usage: set_theme NAME [ [--ssh] ]'
    test -z "$argv" && echo $help_txt && return 1
    argparse $options -- $argv

    set -l file ""
    # set -q _flag_ssh && set file "$XDG_DATA_HOME/fish/theme" || "$XDG_DATA_HOME/fish/ssh_theme"_
    if set -q _flag_ssh
        echo "Setting ssh theme"
        set file "$XDG_DATA_HOME/fish/ssh_theme"
    else
        echo "Setting theme"
        set file "$XDG_DATA_HOME/fish/theme"
    end

	echo "$theme_name" > "$file"
    # set -e __fundle_plugin_names
    # set -e __fundle_name_paths
    # set -e __fundle_plugin_urls
    # set -e __fundle_plugin_name_paths
    echo "Reload shell to see changes"
end

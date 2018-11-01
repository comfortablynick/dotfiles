# Defined in /tmp/fish.jhUzNt/set_theme.fish @ line 2
function set_theme --description 'set local theme file and reload shell' --argument theme_name
	echo "$theme_name" > "$XDG_DATA_HOME/fish/theme"
    set -e __fundle_plugin_names
    set -e __fundle_name_paths
    set -e __fundle_plugin_urls
    set -e __fundle_plugin_name_paths
    frel
end

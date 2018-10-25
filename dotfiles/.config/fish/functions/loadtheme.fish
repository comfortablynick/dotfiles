# Defined in - @ line 2
function loadtheme --argument target_theme
	set -l plugin_dir $XDG_DATA_HOME/fish_plugins/themes/$target_theme
    if not test -d $plugin_dir
        echo "Cannot find $target_theme in themes directory."
        return 0
    end
    #Using OMF
    #if test -f $OMF_CONFIG/theme
    #    read current_theme <$OMF_CONFIG/theme
    #    test "$target_theme" -eq "$current_theme"
    #    and return 0
    #end
    #if test "$FISH_THEME" = $target_theme
    #  echo "$target_theme already set as FISH_THEME"
    #  return 1
    #end
    for f in (find $plugin_dir -maxdepth 2 -iname "*.fish")
        source $f
    end
    set -gx FISH_THEME $target_theme
    return 0
end

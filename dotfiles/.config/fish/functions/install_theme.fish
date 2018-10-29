# Defined in - @ line 2
function install_theme --description 'Clone theme repo to fish_plugins dir'
	set -l pkg_name $argv[1]
    set -l git_repo $argv[2]
    set -l themes_dir
    if set -q FISH_PLUGIN_PATH
        set themes_dir "$FISH_PLUGIN_PATH/themes"
        if test ! -d "$themes_dir/$pkg_name"
            echo "Cloning $pkg_name"
            command mkdir -p $themes_dir/$pkg_name
            git clone $git_repo $themes_dir/$pkg_name
        else
            echo "Directory $themes_dir/$pkg_name already exists! Aborting."
        end
    else
        echo "FISH_PLUGIN_PATH env var not set! Aborting."
    end
end

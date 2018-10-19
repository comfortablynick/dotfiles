# Defined in - @ line 2
function frel --description 'Reload fish shell'
	on_exit
    set_color $fish_color_autosuggestion
    echo 'Reloading fish shell!'
    clear
    source "$XDG_CONFIG_HOME/fish/config.fish"
end

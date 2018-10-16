# Defined in - @ line 2
function frel --description 'Reload fish shell'
	set_color $fish_color_autosuggestion
    echo 'Reloading fish shell!'
    reset
    source ~/.config/fish/config.fish
end

# Defined in - @ line 2
function on_exit --description 'Destroy fish_universal_variables on shell exit' --on-event fish_exit
	set -l univars "$XDG_CONFIG_HOME/fish/fish_universal_variables"
    if test -e $univars
        echo "Destroying fish_universal_variables... "
        sleep 0.25
        rm $univars
        echo "Done! Exiting shell."
        sleep 0.5
    else
        echo "No fish_universal_variables file found! Exiting shell."
        sleep 0.25
    end
end

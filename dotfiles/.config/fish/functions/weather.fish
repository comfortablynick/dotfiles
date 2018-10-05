# Defined in - @ line 2
function weather --description 'Display cli output of weather'
	set -l script "$HOME/git/python/shell/weather/weather.py"
    if type -q $script
        python $script
    end
end

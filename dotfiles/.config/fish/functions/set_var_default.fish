# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.Sph0Q9/set_var_default.fish @ line 1
function set_var_default --description 'set supplied value if not already set' --argument var_name default
	if not set -q $var_name
        set -g $var_name $default
    end
end

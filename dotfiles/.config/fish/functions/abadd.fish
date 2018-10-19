# Defined in - @ line 2
function abadd --description 'Add abbreviation and append to fish.config for custom handling'
	abbr -a $argv
    and echo "abbr $argv" >>"$XDG_CONFIG_HOME/fish/config.fish"
    and echo "Abbr added and also appended to fish.config!"
end

# Defined in - @ line 2
function chtheme --description 'Change theme and silence OMF errors'
	omf theme $argv 2>/dev/null
end

# Defined in /tmp/fish.PI3rkv/update_fish.fish @ line 1
function update_fish --description 'Pull fish source and build'
	git -C ~/src/fish-shell pull && build_fish
end

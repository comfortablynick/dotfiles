# Defined in /tmp/fish.uYpVgV/j.fish @ line 2
function j --description 'Jump to directory based on past behavior'
	set -l dir (jump cd $argv)
    test -d "$dir"
    and cd "$dir"
end

# Defined in /tmp/fish.luRfPm/f.fish @ line 2
function f --description 'fzf wrapper; prefer fzf-tmux if available'
	type -q fzf-tmux; and fzf-tmux; or fzf	
end

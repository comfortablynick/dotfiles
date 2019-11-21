# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.1ZYkX9/vim.fish @ line 2
function vim --description 'Calls Neovim or Vim based on nvim and availability'
	set -qg VISUAL && set -eg VISUAL
    set -qg EDITOR && set -eg EDITOR
	if string match -qr -- '.vim|.fish' $argv
        command nvim $argv
        return
    end
	if type -qf "$VISUAL" 2>/dev/null
        command $VISUAL $argv
    else if type -qf "$EDITOR" 2>/dev/null
        command $EDITOR $argv
    else
        # No VISUAL/EDITOR defined; call vim
        command nvim $argv
    end
end

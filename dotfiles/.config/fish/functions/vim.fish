# Defined in - @ line 2
function vim --description 'Calls Neovim or Vim based on nvim and availability'
	if type -qf nvim
        command nvim $argv
    else if type -qf vim
        command vim $argv
    end
end

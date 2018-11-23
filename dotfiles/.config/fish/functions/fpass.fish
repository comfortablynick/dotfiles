# Defined in /tmp/fish.SFEBgS/fpass.fish @ line 1
function fpass --description 'Fuzzy-find a Lastpass entry and copy the password'
	if not lpass status -q
    lpass login $EMAIL
  end

  if not lpass status -q
    exit
  end

  lpass ls | fzf | string replace -r -a '.+\[id: (\d+)\]' '$1' | read -l result; and lpass show -c --password "$result"
end

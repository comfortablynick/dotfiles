function auri -d 'Use aur helper to install packages'
    # TODO: why doesn't this work?'
    set pkgs (_aur_helper --color=always -Slq | _fzf_wrapper -q "$argv" -m --preview '_aur_helper --color=always -Si {1}')
    if set -n "$pkgs"
        _aur_helper -S $pkgs
    end
end

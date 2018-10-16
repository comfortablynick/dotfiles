# Defined in - @ line 2
function fisher --description 'fish package manager' --argument cmd
	if not command which curl >/dev/null
        echo "curl is required to use fisher -- install curl and try again" >&2
        return 1
    end

    test -z "$XDG_CACHE_HOME"
    and set XDG_CACHE_HOME ~/.cache
    test -z "$XDG_CONFIG_HOME"
    and set XDG_CONFIG_HOME ~/.config

    set -g fish_config $XDG_CONFIG_HOME/fish
    set -g fisher_cache $XDG_CACHE_HOME/fisher
    set -g fisher_config $XDG_CONFIG_HOME/fisher

    test -z "$fisher_path"
    and set -g fisher_path $fish_config

    command mkdir -p {$fish_config,$fisher_path}/{functions,completions,conf.d} $fisher_cache

    if test ! -e "$fisher_path/completions/fisher.fish"
        echo "fisher self-complete" >$fisher_path/completions/fisher.fish
        _fisher_self_complete
    end

    switch "$cmd"
        case self-complete
            _fisher_self_complete
        case ls
            _fisher_ls | command sed "s|$HOME|~|"
        case -v {,--}version
            _fisher_version (status -f)
        case -h {,--}help
            _fisher_help
        case self-update
            _fisher_self_update (status -f)
            or return
            _fisher_self_complete
        case self-uninstall
            _fisher_self_uninstall
        case add rm ""
            if test ! -z "$argv"
                if not isatty
                    while read -l i
                        set argv $argv $i
                    end
                end
            end
            _fisher_commit $argv
            or return
            _fisher_self_complete
        case \*
            echo "error: unknown flag or command \"$cmd\"" >&2
            _fisher_help >&2
            return 1
    end
end

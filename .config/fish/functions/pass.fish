# Defined in /tmp/fish.DDiDVJ/pass.fish @ line 2
function pass --description 'fuzzy find passwords from lastpass-cli'
    argparse h/help p/password -- $argv; or return
    if set -q _flag_help
        echo 'Fuzzy find passwords from lastpass-cli'
        echo
        echo 'Usage: pass [{-h|--help}{-p|--password}] PATTERN'
        echo
        echo 'PATTERN    Search string to pass to `lpass ls`'
        echo
        echo 'Flags:'
        echo '  -h, --help          Show this help message and exit'
        echo '  -p, --password      Output password only to stdout'
        return 1
    end

    lpass ls | fzf-tmux -1 -q "$argv" | read -l result
    set result (string replace -r -a '.+\[id: (\d+)\]' '$1' -- $result)
    set -l lpass_args
    if set -q _flag_password
        set lpass_args --password
    end
    and lpass show $lpass_args $result
end

function pass --description 'fuzzy find passwords from lastpass-cli'
    argparse h/help p/password -- $argv; or return
    if set -q _flag_help
        echo "\
Fuzzy find passwords from lastpass-cli

Usage: pass [{-h|--help}{-p|--password}] PATTERN

PATTERN    Search string to pass to `lpass ls`

Flags:
  -h, --help          Show this help message and exit
  -p, --password      Output password only to stdout\
" 1>&2
        return 1
    end
    if not lpass status -q
        echo (set_color brred)'error: '(set_color -o brblue)'must log in to lpass cli first'(set_color normal) 1>&2
        return 1
    end
    lpass ls | fzf-tmux -1 -q "$argv" | read -l result
    if test -z "$result"
        return 1
    end
    set result (string replace -r -a '.+\[id: (\d+)\]' '$1' -- $result)
    set -l lpass_args
    if set -q _flag_password
        set lpass_args --password
    end
    and lpass show $lpass_args $result
end

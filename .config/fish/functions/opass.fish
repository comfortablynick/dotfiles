function opass --description 'fuzzy find passwords from 1password cli (op)'
    argparse h/help p/password -- $argv; or return
    if set -q _flag_help
        echo "\
Fuzzy find passwords from 1password

Usage: opass [{-h|--help}{-p|--password}] PATTERN

PATTERN    Search string to query `op item list`

Flags:
  -h, --help          Show this help message and exit
  -p, --password      Output password only to stdout\
" 1>&2
        return 1
    end
    if not op whoami > /dev/null
        echo (set_color brred)'error: '(set_color -o brblue)'must log in to op cli first'(set_color normal) 1>&2
        return 1
    end
    set result (op item list | _fzf_wrapper -1 -q "$argv")
    test -z $result; and return 1
    set result (string split ' ' -f 1 -- $result)
    set -l op_args
    if set -q _flag_password
        set op_args --fields label=password
    end
    op item get $op_args $result
end

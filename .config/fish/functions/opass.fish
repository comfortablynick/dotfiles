function opass --description 'fuzzy find passwords from 1password cli (op)'
    argparse h/help p/password -- $argv; or return
    if set -q _flag_help
        echo "\
Fuzzy find passwords from 1password

Usage: opass [{-h|--help}{-l|--login}{-p|--password}] PATTERN

PATTERN    Search string to query `op item list`

Flags:
  -h, --help          Show this help message and exit
  -p, --password      Output password only to stdout\
" 1>&2
        return 1
    end
    if not op whoami &>/dev/null
        if set -q OP_ACCOUNT_PASSWORD
            eval (echo $OP_ACCOUNT_PASSWORD | op signin)
        else
            eval (op signin)
        end
    end
    set result (op item list | _fzf_wrapper -1 -q "$argv")
    test -z $result; and return 1
    set result (string split ' ' -f 1 -- $result)
    set -l op_args
    if set -q _flag_password
        set op_args --reveal --fields label=password
    end
    op item get $op_args $result
end

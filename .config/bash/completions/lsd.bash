_lsd() {
    local i cur prev opts cmd
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd=""
    opts=""

    for i in ${COMP_WORDS[@]}
    do
        case "${cmd},${i}" in
            ",$1")
                cmd="lsd"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        lsd)
            opts="-a -A -F -l -1 -R -h -d -t -S -X -G -v -U -r -I -i -g -L -Z -N -V --all --almost-all --color --icon --icon-theme --classify --long --ignore-config --config-file --oneline --recursive --human-readable --tree --depth --directory-only --permission --size --total-size --date --timesort --sizesort --extensionsort --gitsort --versionsort --sort --no-sort --reverse --group-dirs --group-directories-first --blocks --classic --no-symlink --ignore-glob --inode --git --dereference --context --hyperlink --header --truncate-owner-after --truncate-owner-marker --system-protected --literal --help --version [FILE]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --color)
                    COMPREPLY=($(compgen -W "always auto never" -- "${cur}"))
                    return 0
                    ;;
                --icon)
                    COMPREPLY=($(compgen -W "always auto never" -- "${cur}"))
                    return 0
                    ;;
                --icon-theme)
                    COMPREPLY=($(compgen -W "fancy unicode" -- "${cur}"))
                    return 0
                    ;;
                --config-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --depth)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --permission)
                    COMPREPLY=($(compgen -W "rwx octal attributes disable" -- "${cur}"))
                    return 0
                    ;;
                --size)
                    COMPREPLY=($(compgen -W "default short bytes" -- "${cur}"))
                    return 0
                    ;;
                --date)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --sort)
                    COMPREPLY=($(compgen -W "size time version extension git none" -- "${cur}"))
                    return 0
                    ;;
                --group-dirs)
                    COMPREPLY=($(compgen -W "none first last" -- "${cur}"))
                    return 0
                    ;;
                --blocks)
                    COMPREPLY=($(compgen -W "permission user group context size date name inode links git" -- "${cur}"))
                    return 0
                    ;;
                --ignore-glob)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -I)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --hyperlink)
                    COMPREPLY=($(compgen -W "always auto never" -- "${cur}"))
                    return 0
                    ;;
                --truncate-owner-after)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --truncate-owner-marker)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
    esac
}

if [[ "${BASH_VERSINFO[0]}" -eq 4 && "${BASH_VERSINFO[1]}" -ge 4 || "${BASH_VERSINFO[0]}" -gt 4 ]]; then
    complete -F _lsd -o nosort -o bashdefault -o default lsd
else
    complete -F _lsd -o bashdefault -o default lsd
fi

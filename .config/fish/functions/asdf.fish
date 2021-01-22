function asdf --description 'Wrapper for asdf to enable export of variables'
    set -l command $argv[1]
    set -e argv[1]
    set -l asdf_bin $HOME/.asdf/bin/asdf

    if not test -e $asdf_bin
        echo -e "error: asdf not found at path `$asdf_bin'"
        return 1
    end

    switch "$command"
        case shell
            # source commands that need to export variables
            source ($asdf_bin export-shell-version fish $argv)
        case '*'
            # forward other commands to asdf script
            $asdf_bin $command $argv
    end
end

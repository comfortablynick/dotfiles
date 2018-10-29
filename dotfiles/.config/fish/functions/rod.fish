# Defined in /tmp/fish.MouNgV/rod.fish @ line 2
function rod --description 'run rod'
	if __rod_no_git
        return 1
    end
    set -l sub_args ""

    switch (count $argv)
        case 0
            __rod_print_help
            return 1
        case 1
        case '*'
            set sub_args $argv[2..-1]
    end

    switch $argv[1]
        case "init"
            __rod_init $sub_args
        case "plugin"
            __rod_plugin $sub_args
        case "list"
            __rod_list $sub_args
        case "install"
            __rod_install $sub_args
        case "update"
            __rod_install __update $sub_args
        case "clean"
            __rod_clean
        case "self-update"
            __rod_self_update
        case "version" -v --version
            __rod_print_version
        case "help" -h --help
            __rod_print_help
            return 0
        case "*"
            __rod_print_help
            return 1
    end
end

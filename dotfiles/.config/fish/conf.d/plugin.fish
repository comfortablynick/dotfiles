# Defined in /tmp/fish.Xv2S7G/fundle_plugin.fish @ line 2
function _load_plugin --description 'add plugin to fish'
	set -l options 'u/url=' 'p/path=' 'c/cond=' 'h/help'
    set -l help_txt "usage: plugin NAME [[--url URL ] [--path PATH]]"
    test -z "$argv" && echo $help_txt && return 1
    argparse $options -- $argv

    set -l name ""
    set -l plugin_url ""
    set -l plugin_path "."
    set -l plugin_cond ""
    set -l cond_eval true

    # Process options
    set -q _flag_help && echo "$help_txt" && return 0
    set -q _flag_url && set plugin_url $_flag_url
    set -q _flag_path && set plugin_path $_flag_path
    set -q _flag_cond && set plugin_cond $_flag_cond

    if test -z "$argv"
        echo "NAME is required!"
        echo $help_txt
    else
        set name $argv
    end

    test -z "$plugin_url"; and set plugin_url (__fundle_get_url $name)
	if not contains $name $__plugin_names # ; and test $cond_eval
		set -g __plugin_names $__plugin_names $name
		set -g __plugin_urls $__plugin_urls $plugin_url
		set -g __plugin_name_paths $__plugin_name_paths $name:$plugin_path
	end
end

function plugin --description "manage fish plugins"
	set -l sub_args ""

	switch (count $argv)
		case 0
			__fundle_print_help
			return 1
		case 1
		case '*'
			set sub_args $argv[2..-1]
	end
    set -l main_arg $argv[1]
	switch $main_arg
		case "init"
            #	__fundle_init $sub_args
		case "plugin"
            #__fundle_plugin $sub_args
		case "load"
            #__fundle_load $sub_args
		case "list"
            #__fundle_list $sub_args
		case "install"
            #	__fundle_install $sub_args
		case "update"
            #__fundle_install __update $sub_args
		case "clean"
            #__fundle_clean
		case "self-update"
            #__fundle_self_update
		case "version" -v --version
            #__fundle_version
		case "help" -h --help
			__fundle_print_help
			return 0
		case "*"
            _load_plugin $main_arg
	end
end
# vim:set fdm=expr:fde=getline(v:lnum)=~'^function.*$'?'>1':1:

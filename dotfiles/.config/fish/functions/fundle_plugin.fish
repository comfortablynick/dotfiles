# Defined in /tmp/fish.Xv2S7G/fundle_plugin.fish @ line 2
function fundle_plugin --description 'add plugin to fundle'
	set -l options 'u/url=' 'p/path=' 'c/cond=' 'h/help'
    set -l help_txt "usage: fundle plugin NAME [[--url URL ] [--path PATH]]"
    test -z "$argv" && echo $help_txt && return 1
    argparse $options -- $argv

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
    end

    test -z "$plugin_url"; and set plugin_url (__fundle_get_url $name)
    # test $cond_eval && echo "true" || echo "false"
	if not contains $name $__fundle_plugin_names # ; and test $cond_eval
		set -g __fundle_plugin_names $__fundle_plugin_names $name
		set -g __fundle_plugin_urls $__fundle_plugin_urls $plugin_url
		set -g __fundle_plugin_name_paths $__fundle_plugin_name_paths $name:$plugin_path
	end
end

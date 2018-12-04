# Defined in /tmp/fish.ohrrKa/set_editor.fish @ line 2
function set_editor --description 'set universal/environment variables for EDITOR and VISUAL'
	set -l options 'h/help' 't/toggle' 'v/vim' 'n/nvim'

    # Assemble help text
    set -l help_txt 'usage: set_editor [ [--toggle] | [--vim] | [--nvim] ]'
    set -a help_txt '\n\nset universal/environment variables for EDITOR and VISUAL'
    set -a help_txt '\n\noptional arguments:'
    set -a help_txt '\n-t, --toggle:\t\ttoggle editor between vim/nvim'
    set -a help_txt '\n-v, --vim:\t\tset editor to vim'
    set -a help_txt '\n-n, --nvim:\t\tset editor to nvim'

    test -z "$argv" && echo -e $help_txt && return 1
    argparse --name=set_editor $options -- $argv
    or return

    # Parse arguments
    set -l new_editor
    if set -q _flag_toggle
        switch "$EDITOR"
            case 'vim'
                set new_editor 'nvim'
            case 'nvim'
                set new_editor 'vim'
            case '*'
                echo '$EDITOR not set! Toggle failed.'
        end
    else if set -q _flag_vim
        set new_editor 'vim'
    else if set -q _flag_nvim
        set new_editor 'nvim'
    else if set -q _flag_help
        echo -e $help_txt
        return 0
    else
        echo "set_editor: no valid option found in [$argv]."
        echo -e $help_txt
        return 1
    end

    # Set $EDITOR and $VISUAL
    # Erase global first so no conflicts
    if test -n "$new_editor"
        set -eg EDITOR; set -Ux EDITOR "$new_editor"; set -g EDITOR "$new_editor"
        set -eg VISUAL; set -Ux VISUAL "$new_editor"; set -g EDITOR "$new_editor"
        echo "New editor set to $new_editor."
        return 0
    else
        return 1
    end
end

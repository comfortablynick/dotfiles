function fish_prompt
    # name: Sorin
    # author: Leonard Hecker <leonard@hecker.io>

    # Sources:
    # - General theme setup: https://github.com/sorin-ionescu/prezto/blob/d275f316ffdd0bbd075afbff677c3e00791fba16/modules/prompt/functions/prompt_sorin_setup
    # - Extraction of git info: https://github.com/sorin-ionescu/prezto/blob/d275f316ffdd0bbd075afbff677c3e00791fba16/modules/git/functions/git-info#L180-L441
    set -l virtualenv ""
    set -l user_and_host ""
    set -l root_indicator ""
    set -l pwd ""
    set -l git_info ""
    set -l cmd_status $status
    set -l prompt_symbol ""
    set -l sorin_prompt_color $sorin_prompt_color

    # Git
    if type -q gitprompt
        set git_info (gitprompt)
    else if type -q gitprompt.py
        if test $sorin_use_gitprompt_async -eq 1
            set -g _sorin_gitprompt_display (_sorin_gitprompt)
        else
            set git_info (gitprompt.py)
        end
    else
        set git_info (_sorin_git_info)
    end

    # Python virtualenv
    if test -n "$VIRTUAL_ENV"
        set virtualenv $sorin_virtualenv_color(basename "$VIRTUAL_ENV")$sorin_color_normal
    end

    # SSH User/hostname
    if test -n "$SSH_CONNECTION"
        set user_and_host $sorin_username_color$USER$sorin_color_gray'@'$sorin_host_color(prompt_hostname)' '
    end

    # PWD
    set pwd $sorin_pwd_color(prompt_pwd)$sorin_color_normal


    # Last command status
    if test $cmd_status -ne 0
        set sorin_prompt_color (set_color red)
    end

    # Root
    if test "$USER" = 'root'
        set root_indicator $sorin_root_color'# '
    end

    # Prompt Symbol
    set prompt_symbol $sorin_prompt_color$sorin_symbol_prompt$sorin_color_normal

    echo -n \n
    echo "$pwd$git_info"
    echo "$virtualenv $prompt_symbol"
end

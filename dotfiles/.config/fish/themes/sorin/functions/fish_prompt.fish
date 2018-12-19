function fish_prompt
    # name: Sorin
    # author: Leonard Hecker <leonard@hecker.io>

    # Sources:
    # - General theme setup: https://github.com/sorin-ionescu/prezto/blob/d275f316ffdd0bbd075afbff677c3e00791fba16/modules/prompt/functions/prompt_sorin_setup
    # - Extraction of git info: https://github.com/sorin-ionescu/prezto/blob/d275f316ffdd0bbd075afbff677c3e00791fba16/modules/git/functions/git-info#L180-L441
    echo -n \n
    if test -n "$SSH_TTY"
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
    end

    echo -n (set_color brblue)(prompt_pwd)' '

    set_color -o
    if test "$USER" = 'root'
        echo -n (set_color red)'# '
    end
    # echo -n (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '
    echo -n (set_color green)'$ '
    set_color normal
end

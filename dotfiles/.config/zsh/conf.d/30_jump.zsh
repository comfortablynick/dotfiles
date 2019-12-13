if (( $+commands[jump] )); then
    # from eval "$(jump shell zsh)"
    __jump_chpwd() {
      jump chdir
    }

    jump_completion() {
      reply=(${(f)"$(jump hint $@)"})
    }

    j() {
      local dir="$(jump cd $@)"
      test -d "$dir" && cd "$dir"
    }

    typeset -gaU chpwd_functions
    chpwd_functions+=__jump_chpwd

    compctl -U -K jump_completion j
fi

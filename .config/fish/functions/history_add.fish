function history_add --description 'Manually add item to fish_history'
    # From: https://unix.stackexchange.com/questions/631733/how-to-write-a-command-to-history-in-fish-shell
    begin
        flock 1
        and echo -- '- cmd:' (
      string replace -- \n \\n (string join ' ' $argv) | string replace \\ \\\\
    )
        and date +'  when: %s'
        # TODO: bother adding `paths:` to the entry?
    end >>$__fish_user_data_dir/fish_history
    and history merge
end

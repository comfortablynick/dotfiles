function _sorin_async_handler --on-signal WINCH
    set -l mypid $fish_pid
    set -l value (eval echo "\$prompt_sorin_gitprompt_$mypid")
    set -e prompt_sorin_gitprompt_$mypid
    set -g _sorin_gitprompt_output (echo "$value")
    set -e _sorin_gitprompt_async_running
    set -g _sorin_prompt_refresh
    commandline -f repaint
end

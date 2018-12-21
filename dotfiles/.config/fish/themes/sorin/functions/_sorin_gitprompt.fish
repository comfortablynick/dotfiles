function _sorin_gitprompt --on-variable PWD
    if not set -q _sorin_gitprompt_async_running
        set -l dir (dirname (status --current-filename))
        set -g _sorin_gitprompt_async_running
        command /usr/bin/env fish $dir/_sorin_async.fish $fish_pid &
    end
end

# Defined in /tmp/fish.HAdB52/gitprompt.fish @ line 2
function gitprompt
	if not set -q __GIT_PROMPT_DIR
        set __GIT_PROMPT_DIR ~/.bash-git-prompt
    end

    # Colors
    set ResetColor (set_color normal)
    set Red (set_color red)
    set Yellow (set_color yellow)
    set Blue (set_color brblue)
    set Green (set_color green)
    set WHITE (set_color white)

    # Bold
    set BGreen (set_color -o green)
    set IBlack (set_color -o black)
    set Magenta (set_color -o purple)

    # Space character (easily adjust spacing)
    set Space ''

    # Default values for the appearance of the prompt. Configure at will.
    set GIT_PROMPT_PREFIX "("
    set GIT_PROMPT_SUFFIX ")"
    set GIT_PROMPT_SEPARATOR "|"
    set GIT_PROMPT_BRANCH "$Green"
    set GIT_PROMPT_STAGED "$Green⬤$Space"
    set GIT_PROMPT_CONFLICTS "$Red✖$Space"
    set GIT_PROMPT_CHANGED "$Red±$Space"
    set GIT_PROMPT_REMOTE "$Space"
    set GIT_PROMPT_UNTRACKED "$Blue…"
    set GIT_PROMPT_STASHED "⚑$Space"
    set GIT_PROMPT_CLEAN "$BGreen✔"

    set -e __CURRENT_GIT_STATUS
    set gitstatus "$__GIT_PROMPT_DIR/gitstatus.py"

    set _GIT_STATUS (python $gitstatus)
    set __CURRENT_GIT_STATUS $_GIT_STATUS

    set __CURRENT_GIT_STATUS_PARAM_COUNT (count $__CURRENT_GIT_STATUS)

    if not test "0" -eq $__CURRENT_GIT_STATUS_PARAM_COUNT
        set GIT_BRANCH $__CURRENT_GIT_STATUS[1]
        set GIT_REMOTE "$__CURRENT_GIT_STATUS[2]"
        if contains "." "$GIT_REMOTE"
            set -e GIT_REMOTE
        end
        set GIT_STAGED $__CURRENT_GIT_STATUS[3]
        set GIT_CONFLICTS $__CURRENT_GIT_STATUS[4]
        set GIT_CHANGED $__CURRENT_GIT_STATUS[5]
        set GIT_UNTRACKED $__CURRENT_GIT_STATUS[6]
        set GIT_STASHED $__CURRENT_GIT_STATUS[7]
        set GIT_CLEAN $__CURRENT_GIT_STATUS[8]
    end

    if test -n "$__CURRENT_GIT_STATUS"
        set STATUS " $GIT_PROMPT_PREFIX$GIT_PROMPT_BRANCH$GIT_BRANCH$ResetColor"

        if set -q GIT_REMOTE
            set STATUS "$STATUS$GIT_PROMPT_REMOTE$GIT_REMOTE$ResetColor"
        end

        set STATUS "$STATUS$GIT_PROMPT_SEPARATOR"

        if [ $GIT_STAGED -ne 0 ]
            set STATUS "$STATUS$GIT_PROMPT_STAGED$GIT_STAGED$ResetColor"
        end

        if [ $GIT_CONFLICTS -ne 0 ]
            set STATUS "$STATUS$GIT_PROMPT_CONFLICTS$GIT_CONFLICTS$ResetColor"
        end

        if [ $GIT_CHANGED -ne 0 ]
            set STATUS "$STATUS$GIT_PROMPT_CHANGED$GIT_CHANGED$ResetColor"
        end

        if [ $GIT_UNTRACKED -ne 0 ]
            set STATUS "$STATUS$GIT_PROMPT_UNTRACKED$GIT_UNTRACKED$ResetColor"
        end

        if [ $GIT_STASHED -ne 0 ]
            set STATUS "$STATUS$GIT_PROMPT_STASHED$GIT_STASHED$ResetColor"
        end

        if [ $GIT_CLEAN -eq 1 ]
            set STATUS "$STATUS$GIT_PROMPT_CLEAN"
        end

        set STATUS "$STATUS$ResetColor$GIT_PROMPT_SUFFIX"
    else
        set STATUS ""
    end

    echo -e "$STATUS"
end

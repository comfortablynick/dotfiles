# GLOBAL VARS {{{
# git
set -g custom_git_prompt false # Use custom prompt rather than fish

if test "$custom_git_prompt" = true
    set -g glyph_git_has_staged_changes '±' # Alternatives: ~+±
    set -g glyph_git_has_stashes '≡'
    set -g glyph_git_has_untracked_files '…' # Alternatives: …☡+±
    set -g glyph_git_is_ahead '⭱' # Alternatives: ⭱⭡↑⤽⤼⇡
    set -g glyph_git_is_behind '⭳' # Alternatives: ⭳⭣↓⤽⤼⇣
    set -g glyph_git_is_dirty '✚'
    set -g glyph_git_is_diverged '⭿' # Alternatives: ⭿⮁⇅ ⇕⬍ ⤲⤱⤮⤭ 🔄🔀
    set -g glyph_git_on_branch '🜉' # Alternatives: 🜉⎇
    set -g glyph_git_on_detached '⌀'
    set -g glyph_git_on_tag '⌂' # Alternatives 🏷⌂
end

# system
set -g glyph_bg_jobs '⚒' # Alternatives: ⛭⚙⚒
set -g glyph_input_start '❭' # Alternatives: 〉❭❯❱⟩⟫
set -g glyph_regular_user '' # Alternatives: •
set -g glyph_status_zero '•'
set -g glyph_superpower '⌁' # Alternatives: 🗲⚡⌁ϟ

# node
set -g glyph_nodejs_logo '⬡' # Alternatives: ⬡⌬⏣⬢

# }}}
function fish_prompt --description 'bigfish: A long two-lines fish prompt' # {{{
    # Requires to be set before any other set calls
    set -l last_status $status
    set -l leftPrompt '╭╴ '
    set -l padding ''
    set -l rightPrompt ''
    set -l bottomPrompt '╰╴'
    set -l leftSep ' ▶ '
    set -l rightSep ' ◀ '

    # Assemble the left prompt

    # Current directory
    set leftPrompt (bf_concat_segments $leftPrompt (prompt_pwd) blue normal true)

    # Display gear if there are any background jobs
    if test (jobs | wc -l) -gt 0
        set leftPrompt (bf_concat_segments $leftPrompt $leftSep grey normal)
        set leftPrompt (bf_concat_segments $leftPrompt $glyph_bg_jobs magenta normal true)
    end

    # git
    set -l git_status ""
    # Use custom function if specified, else use fish builtin
    if test "$custom_git_prompt" = true
        set git_status (bf_git_status)
    else
        set git_status (__fish_git_prompt)
    end

    if test -n "$git_status"
      set leftPrompt (bf_concat_segments $leftPrompt $leftSep grey normal)
      set leftPrompt (bf_concat_segments $leftPrompt $git_status normal normal)
    end

    # node
    if command -v node > /dev/null; and lookup package.json > /dev/null
        set leftPrompt (bf_concat_segments $leftPrompt $leftSep grey normal)
        set leftPrompt (bf_concat_segments $leftPrompt \
            (node --version | sed "s/v/$glyph_nodejs_logo/") brgreen normal)
    end


    # Assemble the right prompt if > 100 columns
    if test "$COLUMNS" -gt 100
        # Last command duration
        set rightPrompt (bf_concat_segments $rightPrompt \
            (echo $CMD_DURATION | humanize_duration) grey normal true)
        set rightPrompt (bf_concat_segments $rightPrompt $rightSep grey normal)
        # When did the last command finish
        set rightPrompt (bf_concat_segments $rightPrompt (date '+%T') grey normal)
        set rightPrompt (bf_concat_segments $rightPrompt $rightSep grey normal)
        # Last command's status code
        set rightPrompt (bf_concat_segments $rightPrompt \
            (test 0 = $last_status; and echo $glyph_status_zero; or echo $last_status) \
            (test 0 = $last_status; and echo grey; or echo red) normal \
            (test 0 = $last_status; and echo false; or echo true))

        # Calculate padding
        set paddding (bf_create_padding \
            (math $COLUMNS - (bf_remove_color $leftPrompt$rightPrompt | string length)))
    end

    # Assemble second line of the prompt
    if test (whoami) = "root"
        set bottomPrompt (bf_concat_segments $bottomPrompt \
            "$glyph_superpower$glyph_input_start " red normal)
    else
        set bottomPrompt (bf_concat_segments $bottomPrompt \
            "$glyph_regular_user$glyph_input_start " grey normal)
    end

    # Print the prompt
    printf "\n"
    # Print first line of the fish prompt
    printf "$leftPrompt$paddding$rightPrompt"
    # Jump to next line
    printf \n
    # Print second line of the fish prompt
    printf $bottomPrompt

end
# }}}
function bf_git_modified -d "returns true if git is modified" -a git_status # {{{
    echo (string match "*$glyph_git_is_dirty*" $git_status)
end
# }}}
function bf_git_status -d "retrieve git repo info from vcprompt util" # {{{
    set -l repo ""
    set -l branch_glyph ""
    set -l branch ""
    set -l branch_color "green"
    set -l revision ""
    set -l untracked ""
    set -l modified ""
    set -l output ""

    # Call vcprompt
    set -l vcp_output (vcprompt -f "repo:%n branch:%b revision:%r untracked:%u modified:%m" | string split ' ')
    if test -n "$vcp_output"
        for arg in $vcp_output
            set -l arg_pair (string split ':' $arg)
            set -l arg_name $arg_pair[1]
            set -l arg_val $arg_pair[2]
            if test -n "$arg_val"
                switch "$arg_name"
                    case "repo"
                        set repo $arg_val
                    case "branch"
                        set branch_glyph $glyph_git_on_branch
                        set branch $arg_val
                    case "revision"
                        set revision "($arg_val)"
                    case "untracked"
                        set untracked $glyph_git_has_untracked_files
                    case "modified"
                        set modified $glyph_git_is_dirty
                        set branch_color "yellow"
                    case "*"
                end
            end
        end
        # echo "$branch_glyph $branch $revision $untracked $modified"
        # printf "$branch_glyph $branch $revision $untracked $modified"
        set output (bf_concat_segments $output "$branch_glyph $branch " $branch_color normal)
        set output (bf_concat_segments $output "$revision " $branch_color normal)
        set output (bf_concat_segments $output "$modified " red normal)
        set output (bf_concat_segments $output "$untracked" blue normal true)
        echo $output
    end
end
# }}}
function bf_get_git_status_info_old --description 'Get git info text with pglyphs' # {{{
    if git_is_tag
        printf $glyph_git_on_tag
    else if git_is_detached_head
        printf $glyph_git_on_detached
    else
        printf $glyph_git_on_branch
    end

    printf ' %s ' (git_branch_name)

    if not git_is_detached_head; and test -n (git_ahead)
        printf '%s ' (git_ahead $glyph_git_is_ahead $glyph_git_is_behind $glyph_git_is_diverged)
    end

    if git_is_stashed
        printf '%s ' $glyph_git_has_stashes
    end

    if git_is_staged
        printf '%s' $glyph_git_has_staged_changes
    end

    if git_is_dirty
        printf '%s' $glyph_git_is_dirty
    end

    if git_untracked_files > /dev/null
        printf '%s' $glyph_git_has_untracked_files
    end

end
# }}}
function bf_concat_segments --argument-names previous next color bgcolor bold underline --description 'Concact two segments' # {{{
    printf "$previous"(bf_style_string $next $color $bgcolor $bold $underline)
end
# }}}
function bf_style_string --argument-names text color bgcolor bold underline --description 'Style a string' # {{{
    set_color $color --background $bgcolor

    if test -n "$bold" -a "$bold" = true
        set_color --bold
    end

    if test -n "$underline" -a "$underline" = true
        set_color --underline
    end

    printf $text

    set_color normal
end
# }}}
function bf_create_padding --argument-names amount --description 'Print N amount of spaces' # {{{
    printf "%-"$amount"s%s"
end
# }}}
function bf_remove_color --description 'Remove color escape sequences from string' # {{{
    printf $argv | perl -pe 's/\x1b.*?[mGKH]//g'
end
# }}}

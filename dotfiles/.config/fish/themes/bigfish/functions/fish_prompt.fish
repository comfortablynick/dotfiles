# vim:fdl=1:

# SETTINGS {{{1
# git {{{2
set -g glyph_git_has_staged_changes '±' # Alternatives: ~+±
set -g glyph_git_has_stashes '≡'
set -g glyph_git_has_untracked_files '…' # Alternatives: …☡+±
set -g glyph_git_is_ahead '⭱' # Alternatives: ⭱⭡↑⤽⤼⇡
set -g glyph_git_is_behind '⭳' # Alternatives: ⭳⭣↓⤽⤼⇣
set -g glyph_git_is_dirty '✚'
set -g glyph_git_is_diverged '⭿' # Alternatives: ⭿⮁⇅ ⇕⬍ ⤲⤱⤮⤭ 🔄🔀
set -g glyph_git_on_branch ' 🜉' # Alternatives: 🜉⎇
set -g glyph_git_on_detached '⌀'
set -g glyph_git_on_tag '⌂' # Alternatives 🏷⌂
set -g git_is_touched 0
set -g git_is_repo 0
set -g custom_git_prompt 0
set -g git_color 707070

# system {{{2
set -g glyph_bg_jobs '⚒' # Alternatives: ⛭⚙⚒
set -g glyph_input_start '❭' # Alternatives: 〉❭❯❱⟩⟫
set -g glyph_regular_user '•'
set -g glyph_status_zero '•'
set -g glyph_superpower '⌁' # Alternatives: 🗲⚡⌁ϟ

# node {{{2
set -g glyph_nodejs_logo '⬡' # Alternatives: ⬡⌬⏣⬢

# FUNCTIONS {{{1
function fish_prompt --description 'bigfish: A long two-lines fish prompt' #{{{2
    # Requires to be set before any other set calls
    set -l last_status $status
    set -l leftPrompt '╭╴'
    set -l padding ''
    set -l rightPrompt ''
    set -l bottomPrompt '╰╴'
    set -l leftSep ' ▶ '
    set -l rightSep ' ◀ '

    # Assemble the left prompt

    # Current directory
    set leftPrompt (_bf_concat_segments $leftPrompt (prompt_pwd) blue normal true)

    # Display gear if there are any background jobs
    # TODO: don't show bg job if autojump
    if test (jobs | wc -l) -gt 0
        set leftPrompt (_bf_concat_segments $leftPrompt $leftSep grey normal)
        set leftPrompt (_bf_concat_segments $leftPrompt $glyph_bg_jobs magenta normal true)
    end

    # git
    set -l git_status

    # Use custom function if specified, else use fish builtin
    test $custom_git_prompt -eq 1
    and set git_status (_bf_git_status)
    or set git_status (__fish_git_prompt)

    test -n "$git_status"
    and set leftPrompt (_bf_concat_segments $leftPrompt $git_status $git_color normal)

    # node
    # if command -v node > /dev/null # ; and lookup package.json > /dev/null
    #     set leftPrompt (_bf_concat_segments $leftPrompt ' ╱ ' grey normal)
    #     set leftPrompt (_bf_concat_segments $leftPrompt \
    #         (node --version | sed "s/v/$glyph_nodejs_logo/") brgreen normal)
    # end


    # Assemble the right prompt if > 100 columns
    if test "$COLUMNS" -gt 100
        # Last command duration
        set rightPrompt (_bf_concat_segments $rightPrompt \
            (echo $CMD_DURATION | humanize_duration) grey normal true)
        set rightPrompt (_bf_concat_segments $rightPrompt $rightSep grey normal)
        # When did the last command finish
        set rightPrompt (_bf_concat_segments $rightPrompt (date '+%T') grey normal)
        set rightPrompt (_bf_concat_segments $rightPrompt $rightSep grey normal)
        # Last command's status code
        set rightPrompt (_bf_concat_segments $rightPrompt \
            (test 0 = $last_status; and echo $glyph_status_zero; or echo $last_status) \
            (test 0 = $last_status; and echo grey; or echo red) normal \
            (test 0 = $last_status; and echo false; or echo true))

        # Calculate padding
        set padding (_bf_create_padding \
            (math $COLUMNS - (_bf_remove_color $leftPrompt$rightPrompt | string length)))
    end

    # Print the prompt
    printf \n
    # Print first line of the fish prompt
    printf $leftPrompt$padding$rightPrompt
    # Jump to next line
    printf \n
    # Print second line of the fish prompt
    printf $bottomPrompt
end

function _bf_git_status -d "retrieve git repo info from vcprompt util" #{{{2
    set -l repo ""
    set -l branch ""
    set -l revision ""
    set -l untracked ""
    set -l modified ""

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
                        set git_is_repo 1
                    case "branch"
                        set branch $arg_val
                    case "revision"
                        set revision $arg_val
                    case "untracked"
                        set untracked $glyph_git_has_untracked_files
                    case "modified"
                        set modified $glyph_git_is_dirty
                        set git_is_touched 1
                    case "*"
                end
            end
        end
        printf "$glyph_git_on_branch $branch $revision $untracked $modified"
    end
end

function _bf_concat_segments --argument-names previous next color bgcolor bold underline --description 'Concact two segments' #{{{2
    printf "$previous"(_bf_style_string $next $color $bgcolor $bold $underline)
end

function _bf_style_string --argument-names text color bgcolor bold underline --description 'Style a string' #{{{2
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

function _bf_create_padding --argument-names amount --description 'Print N amount of spaces' #{{{2
    printf "%-"$amount"s%s"
end

function _bf_remove_color --description 'Remove color escape sequences from string' #{{{2
    printf $argv | perl -pe 's/\x1b.*?[mGKH]//g'
end

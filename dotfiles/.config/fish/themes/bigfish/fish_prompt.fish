# Defined in /tmp/fish.JDNina/fish_prompt.fish @ line 2
function fish_prompt --description 'bigfish: A long two-lines fish prompt'
	set -l last_status $status
    set -l leftPrompt '╭╴'
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
        # set leftPrompt (bf_concat_segments $leftPrompt $leftSep grey normal)
      set leftPrompt (bf_concat_segments $leftPrompt $git_status normal normal)
    end

    # node
    # if command -v node > /dev/null; and lookup package.json > /dev/null
    #     set leftPrompt (bf_concat_segments $leftPrompt $leftSep grey normal)
    #     set leftPrompt (bf_concat_segments $leftPrompt \
    #         (node --version | sed "s/v/$glyph_nodejs_logo/") brgreen normal)
    # end


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
            "$glyph_superpower$glyph_input_start" red normal)
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

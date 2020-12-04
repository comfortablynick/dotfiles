# vim:fdl=1:
#                 ___
#   ___======____=---=)
# /T            \_--===)
# [ \ (0)   \~    \_-==)
#  \      / )J~~    \-=)
#   \\___/  )JJ~~~   \)
#    \_____/JJJ~~~~    \
#    / \  , \J~~~~~     \
#   (-\)\=|\\\~~~~       L__
#   (\\)  (\\\)_           \==__
#    \V    \\\) ===_____   \\\\\\
#           \V)     \_) \\\\JJ\J\)
#                       /J\JT\JJJJ)
#                       (JJJ| \UUU)
#                        (UU)
# Startup {{{1
# Non-interactive {{{2
if not status --is-interactive
    exit 0
end

# Everything below is for interactive shells
# Welcome message {{{2
set_color $fish_color_autosuggestion
set -l start_time (get_date)
and echo -n 'Sourcing config.fish...  '

# Packages {{{1
# Fisher setup {{{2
if not functions -q fisher
    echo "Downloading fisher..." >&2
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME $HOME/.config
    curl -sL git.io/fisher | source; and fisher install jorgebucaran/fisher
end

# Environment {{{1
# Load from env file {{{2
set -l env_file $HOME/.config/fish/env.fish
set -q env_file_sourced
or set -U env_file_sourced 0

if test -f "$env_file"; and test $env_file_sourced -eq 0
    echo "Reading env from $env_file..."
    source $env_file; and set env_file_sourced 1
end

# Themes {{{1
# Fish git prompt {{{2
# Settings {{{3
set -g __fish_git_prompt_show_informative_status true
set -g __fish_git_prompt_showupstream 'informative'
set -g __fish_git_prompt_showcolorhints true

# Symbols {{{3
# In default fish prompt
set -g __fish_git_prompt_char_cleanstate '✔'
set -g __fish_git_prompt_char_dirtystate '±'
set -g __fish_git_prompt_char_invalidstate '✖'
set -g __fish_git_prompt_char_stagedstate '⬤' # (was: '✚')
set -g __fish_git_prompt_char_stashstate '≡'
set -g __fish_git_prompt_char_stateseparator '|'
set -g __fish_git_prompt_char_untrackedfiles '…'
set -g __fish_git_prompt_char_upstream_ahead '↑'
set -g __fish_git_prompt_char_upstream_behind '↓'
set -g __fish_git_prompt_char_upstream_diverged '≠' # (was: '<>')
set -g __fish_git_prompt_char_upstream_equal '='
set -g __fish_git_prompt_char_upstream_prefix ''

# Not in default fish prompt
set -g __fish_git_prompt_char_detachedstate '➦'
set -g __fish_git_prompt_char_tag '☗'

# Colors {{{3
set -g ___fish_git_prompt_color_flags (set_color --bold blue)
set -g ___fish_git_prompt_color_flags_done (set_color normal)
set -g ___fish_git_prompt_color_branch (set_color green)
set -g ___fish_git_prompt_color_branch_done (set_color normal)
set -g ___fish_git_prompt_color_branch_detached (set_color red)
set -g ___fish_git_prompt_color_branch_detached_done (set_color normal)
set -g ___fish_git_prompt_color_dirtystate (set_color red)
set -g ___fish_git_prompt_color_dirtystate_done (set_color normal)
set -g ___fish_git_prompt_color_stagedstate (set_color green)
set -g ___fish_git_prompt_color_stagedstate_done (set_color normal)

# bobthefish {{{2
if functions -q __bobthefish_colors
    # Set options if term windows is narrow-ish
    if test $COLUMNS -lt 200
        set -g theme_newline_cursor yes
    end

    set -g theme_display_date yes
    set -g theme_date_format "+%a %b %d %I:%M:%S %p"
    set -g theme_date_timezone America/Chicago

    # Are the fancy fonts needed?
    set -g theme_powerline_fonts yes
    set -g theme_nerd_fonts yes

    if test $MOSH_CONNECTION -eq 1
        set -g theme_nerd_fonts no
    end

    # Git
    set -g theme_display_git_master_branch no
    set -g theme_display_git_ahead_verbose yes
    set -g theme_display_git_dirty_verbose yes
    set -g theme_display_git_dirty yes
    set -g theme_display_git_untracked yes

    # Other settings
    set -g theme_avoid_ambiguous_glyphs yes
    set -g fish_prompt_pwd_dir_length 1 # Abbreviate PWD in prompt
    set -g theme_project_dir_length 1 # Abbreviate relative path to proj root
    set -g theme_display_cmd_duration yes # Threshold for showing command dur in ms
    set -g theme_show_exit_status yes # Show code instead of just !

    # Tmux shows user/host
    # Only display if $SSH and no $TMUX
    if test -n "$TMUX"
        set -g theme_display_user no
        set -g theme_display_hostname no
    else
        set -g theme_display_user ssh
        set -g theme_display_hostname ssh
    end

# pure {{{2

else if functions -q _pure_prompt
    set -g pure_symbol_prompt "❯"
    set -g pure_symbol_git_unpulled_commits '↓' # "⇣"
    set -g pure_symbol_git_unpushed_commits '↑' #  "⇡"
    set -g pure_symbol_git_dirty "*"
    set -g pure_symbol_title_bar_separator "—"

    # Prompt colors
    set -g pure_color_primary (set_color brblue)
    set -g pure_color_info (set_color cyan)
    set -g pure_color_mute (set_color 6c6c6c)
    set -g pure_color_success (set_color green)
    set -g pure_color_normal (set_color normal)
    set -g pure_color_danger (set_color red)
    set -g pure_color_warning (set_color yellow)

    # Colors when connected via SSH
    set -g pure_color_ssh_user_normal $pure_color_warning
    set -g pure_color_ssh_hostname $pure_color_mute
    set -g pure_color_ssh_user_root $pure_color_danger

    # Display options
    set -g pure_begin_prompt_with_current_directory false # Loc of u@h; 0 = end, 1 = beg
    set -g pure_separate_prompt_on_error false # Show addl char if error
    set -g pure_threshold_command_duration 5 # Secs elapsed before exec time shown

else
    if type -qf starship
        starship init fish --print-full-init | source
        set fish_greeting
    end
end

# End config {{{1
# Print config.fish load time {{{2
set -l end_time (get_date)
set -l elapsed (math \($end_time - $start_time\))
echo "Completed in $elapsed sec."
set_color brblue; echo 'Done'; set_color normal; echo ''

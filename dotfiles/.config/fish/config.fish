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
# SHELL STARTUP {{{1
# Non-interactive {{{2
if not status --is-interactive
  exit 0
end

# Everything below is for interactive shells
# Welcome message {{{2
set_color $fish_color_autosuggestion
set -l start_time (get_date)
and echo -n 'Sourcing config.fish...  '

# FUNCTIONS {{{1
# ab :: wrap `abbr` so fish linter doesn't complain {{{2
function ab -d "create global abbreviation"
    set -l abbrev $argv[1]
    set -l cmd $argv[2..-1]
    abbr -g $abbrev $cmd
end

# var :: export env var if no univar exists {{{2
function var -d "export environment variable if not defined universally"
    set -l var_name $argv[1]
    set -l var_value $argv[2..-1]
    # Set global var if not set universally
    if not set -qU $var_name
        set -gx $var_name $var_value
    end
end

# j :: alias for __fzf_autojump {{{2
function j -d "alias for __fzf_autojump"
    __fzf_autojump $argv
end

# fun :: alias for fundle to silence config.fish errors {{{2
function fun -d "alias for fundle"
    fundle $argv
end

# _loadtheme :: alias for loadtheme to silence config.fish errors {{{2
function _loadtheme -d "alias for loadtheme for config.fish"
    loadtheme $argv
end


# PACKAGES {{{1
# NOTE: Fisher packages are kept in fishfile
# Theme {{{2
# Get theme from local file
if test -n "$SSH_CONNECTION" -a -f $XDG_DATA_HOME/fish/ssh_theme
    # Get ssh theme from local file
        read local_ssh_theme < $XDG_DATA_HOME/fish/ssh_theme
        set FISH_THEME $local_ssh_theme
else
    if test -f $XDG_DATA_HOME/fish/theme
        read local_theme < $XDG_DATA_HOME/fish/theme
        set FISH_THEME $local_theme
    end
end

# Set options based on ssh connection/term size (if not TMUX)
if test -n "$SSH_CONNECTION" -a "$COLUMNS" -lt 140 -a -z "$TMUX"
    # We're *probably* connecting from iOS
    # Better to use TMUX and name session 'ios'
    set NERD_FONTS 0
end

# Package manager setup {{{2
switch "$FISH_PKG_MGR"
    case "OMF"
        set -gx OMF_PATH "$XDG_DATA_HOME/omf"
        # Install OMF if needed
        if not functions -q omf
          echo "OMF set as pkg manager but not installed. Installing now... "
          curl -L https://get.oh-my.fish | fish
        end
    case "Fisher"
    # Fisher
    if not functions -q fisher
        echo "Installing fisher for the first time..." >&2
        set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME $HOME/.config
        curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
        fish -c fisher
    end
    case "*"
end

# Plugins {{{2
if test "$FISH_PKG_MGR" = "Fundle"
# Themes {{{3
    # fun plugin 'comfortablynick/theme-bobthefish' \
    #     --cond='[ $FISH_THEME = bobthefish ]'

    fun plugin 'bobthefish' --local \
        --cond='[ $FISH_THEME = bobthefish ]' \
        --path="$HOME/git/theme-bobthefish"

    fun plugin 'oh-my-fish/theme-yimmy' \
        --cond='[ $FISH_THEME = yimmy ]'

    fun plugin 'rafaelrinaldi/pure' \
        --cond='[ $FISH_THEME = pure ]'

    fun plugin 'bigfish' --local \
        --cond='[ $FISH_THEME = bigfish ]' \
        --path="$XDG_CONFIG_HOME/fish/themes/bigfish"

    fun plugin 'sorin' --local \
        --cond='[ $FISH_THEME = sorin ]' \
        --path="$XDG_CONFIG_HOME/fish/themes/sorin"

# Utilities {{{4
    fun plugin 'jethrokuan/fzf' \
        --cond='type -q fzf'

# Node.js {{{3
    fun plugin 'FabioAntunes/fish-nvm'
    fun plugin 'edc/bass'

# Test {{{3
    fun plugin 'fisherman/getopts' \
        --cond 'test 1 -eq 2'

# <--- All plugin definitions before this line
    fun init
end

# ENVIRONMENT {{{1
# Load from env file {{{2
set -l env_file "$HOME/.config/fish/env.fish"
set -q env_file_sourced
or set -U env_file_sourced 0

if test -f "$env_file"
    and test $env_file_sourced -eq 0
    echo "Reading env from $env_file..."
    source "$env_file"
    and set env_file_sourced 1
end

# THEMES {{{1
# Themes (manual package management) {{{2
test -z "$FISH_PKG_MGR"
and _loadtheme $FISH_THEME

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
# if test "$FISH_THEME" = 'bobthefish'
if functions -q __bobthefish_colors
    # Set options if term windows is narrow-ish
    if test $COLUMNS -lt 200
        set -g theme_newline_cursor yes
    end

    set -g theme_display_date yes

    # Are the fancy fonts needed?
    set -g theme_powerline_fonts yes
    set -g theme_nerd_fonts no

    # Git
    set -g theme_display_git_master_branch yes
    set -g theme_display_git_ahead_verbose yes
    set -g theme_display_git_dirty_verbose yes
    set -g theme_display_git_dirty yes
    set -g theme_display_git_untracked yes

    # Other settings
    set -g theme_avoid_ambiguous_glyphs yes
    set -g fish_prompt_pwd_dir_length 1 # Abbreviate PWD in prompt
    set -g theme_project_dir_length 1 # Abbreviate relative path to proj root
    set -g theme_display_cmd_duration 0 # Threshold for showing command dur in ms
    set -g theme_date_format "+%a %b %d %I:%M:%S %p"

    # Tmux shows user/host
    # Only display if $SSH and no $TMUX
    if test -n "$TMUX"
        set -g theme_display_user no
        set -g theme_display_hostname no
    else
        set -g theme_display_user ssh
        set -g theme_display_hostname ssh
    end
end

# pure {{{2
# prompt text
# if test "$FISH_THEME" = 'pure'
if functions -q _pure_prompt
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
    set -g pure_begin_prompt_with_current_directory false          # Loc of u@h; 0 = end, 1 = beg
    set -g pure_separate_prompt_on_error false                     # Show addl char if error
    set -g pure_threshold_command_duration 5                       # Secs elapsed before exec time shown
end

# bigfish {{{2
if test "$FISH_THEME" = 'bigfish'
    test $NERD_FONTS -eq 0
    and set -gx glyph_git_on_branch '🜉'

    set -gx glyph_bg_jobs '⚒'
end

# yimmy {{{2
test "$FISH_THEME" = 'yimmy'
# Disable solarized theme
and set -g yimmy_solarized false

# KEYBINDINGS {{{1
# vi-mode with custom keybindings {{{2
# set fish_key_bindings fish_user_vi_key_bindings

# PRE SHELL LOAD {{{1
# TMUX {{{2
# Attach to existing tmux or create a new session using custom function
# Get current session name
if test -n "$TMUX_PANE"
    set -gx TMUX_SESSION (tmux list-panes -t "$TMUX_PANE" -F '#S' | head -n1)
    test "$TMUX_SESSION" = 'ios' && set NERD_FONTS 0
end

# vim {{{2
# Set vim compat if SSH (until there's a better way)
if test -n "$SSH_CONNECTION"
    set -gx VIM_SSH_COMPAT 1
end

# asdf {{{2
set -l asdf_file "$HOME/.asdf/asdf.fish"
test -f "$asdf_file"; and source "$asdf_file"

# END CONFIG {{{1
# Print config.fish load time {{{2
set -l end_time (get_date)
set -l elapsed (math \($end_time - $start_time\))
echo "Completed in $elapsed sec."
set_color brblue; echo 'Done'; set_color normal; echo ''

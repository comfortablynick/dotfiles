# vim:fdl=0:
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

# Set options based on ssh connection/term size
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
        curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
        echo "Reload shell to use fisher."
    end
    # case "FUNDLE"
    #     if not functions -q fundle
    #         curl -sfL https://git.io/fxdrv | fish
    #     end
    case "*"
    # echo "Unknown package manager"
end

# Plugins {{{2
# Themes {{{3
fun plugin 'comfortablynick/theme-bobthefish' \
    --cond='[ $FISH_THEME = bobthefish ]'

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

# Utilities {{{3
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

# THEMES {{{1
# Themes (manual package management) {{{2
test -z "$FISH_PKG_MGR"
and _loadtheme $FISH_THEME

# Git prompt {{{2
set -g __fish_git_prompt_show_informative_status true
set -g __fish_git_prompt_showcolorhints true
set -g ___fish_git_prompt_char_stagedstate ±
set -g ___fish_git_prompt_char_stashstate ≡

# bobthefish {{{2
if test "$FISH_THEME" = 'bobthefish'
    # Set options if term windows is narrow-ish
    set -g theme_short_prompt_cols 140                          # Shorten prompt if cols < this

    # Tmux shows user/host, so we dont need it here
    if test -n "$TMUX"
        set -g theme_display_user no
        set -g theme_display_hostname no
    end
end

# pure {{{2
# prompt text
if test "$FISH_THEME" = 'pure'
    set pure_symbol_prompt "❯"
    set pure_symbol_git_down_arrow "⇣"
    set pure_symbol_git_up_arrow "⇡"
    set pure_symbol_git_dirty "*"
    set pure_symbol_horizontal_bar "—"

    # Prompt colors
    set pure_color_blue (set_color brblue)
    set pure_color_cyan (set_color cyan)
    set pure_color_gray (set_color 6c6c6c)
    set pure_color_green (set_color green)
    set pure_color_normal (set_color normal)
    set pure_color_red (set_color red)
    set pure_color_yellow (set_color yellow)

    # Colors when connected via SSH
    set pure_username_color $pure_color_yellow
    set pure_host_color $pure_color_gray
    set pure_root_color $pure_color_red

    # Display options
    set pure_user_host_location 1                               # Loc of u@h; 0 = end, 1 = beg
    set pure_separate_prompt_on_error 0                         # Show addl char if error
    set pure_command_max_exec_time 5                            # Secs elapsed before exec time shown
end

# bigfish {{{2
if test "$FISH_THEME" = 'bigfish'
    test $NERD_FONTS -eq 1
    and set -gx glyph_git_on_branch '🜉'

    set -gx glyph_bg_jobs '⚒'
end

# yimmy {{{2
if test "$FISH_THEME" = 'yimmy'
    set -g yimmy_solarized false                                    # Solarized color scheme
end

# KEYBINDINGS {{{1
# vi-mode with custom keybindings {{{2
# set fish_key_bindings fish_user_vi_key_bindings

# COLORS {{{1
# Fish color {{{2
set -g fish_color_autosuggestion 707070
set -g fish_color_cancel -r
set -g fish_color_command b294bb
set -g fish_color_comment f0c674
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_end b294bb
set -g fish_color_error cc6666
set -g fish_color_escape 'bryellow'  '--bold'
set -g fish_color_history_current --bold
set -g fish_color_host normal
set -g fish_color_match --background=brblue
set -g fish_color_normal normal
set -g fish_color_operator bryellow
set -g fish_color_param 81a2be
set -g fish_color_quote b5bd68
set -g fish_color_redirection 8abeb7
set -g fish_color_search_match 'bryellow'  '--background=brblack'
set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
set -g fish_color_status red
set -g fish_color_user brgreen
set -g fish_color_valid_path --underline

# Fish pager color {{{2
set -g fish_pager_color_completion
set -g fish_pager_color_description 'b3a06d'  'yellow'
set -g fish_pager_color_prefix 'white'  '--bold'  '--underline'
set -g fish_pager_color_progress 'brwhite'  '--background=cyan'

# STARTUP COMMANDS {{{1
# Python Venv {{{2
test -f "$def_venv"
and source $def_venv

# FZF {{{2
if test -z (type -f fzf 2>/dev/null)
    if not test -d "$HOME/.fzf"
        echo "fzf dir not found. Cloning fzf and installing..."
        command git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    end
    echo "Installing fzf ..."
    ~/.fzf/install --bin --no-key-bindings --no-update-rc
end

# Node Version Manager (NVM) {{{2
if test -z (type -f node 2>/dev/null)
    # nvm
    if not test -d "$HOME/.nvm"
        echo "nvm not found. Cloning nvm..."
        command git clone https://github.com/creationix/nvm.git "$HOME/.nvm"
        cd "$HOME/.nvm"
        command git checkout (command git describe --abbrev=0 --tags --match "v[0-9]*" (git rev-list --tags --max-count=1))
    end

    # Put node binaries in PATH if not already
    if test -d "$node_bin_path"
            set -p PATH "$node_bin_path"
    else
        set -l node_latest (ls -a "$HOME/.nvm/versions/node" | string match -r 'v.*' | sort -V | tail -n1)
        if test -n "$node_latest"
            set -p PATH "$HOME/.nvm/versions/node/$node_latest/bin"
        end
    end
end

# TMux {{{2
# Attach to existing tmux or create a new session using custom function
# Get current session name
if test -n "$TMUX_PANE"
    set -gx TMUX_SESSION (tmux list-panes -t "$TMUX_PANE" -F '#S' | head -n1)
    test "$TMUX_SESSION" = 'ios' && set NERD_FONTS 0
end

# Powerline {{{2
# Start powerline-daemon in bg if it exists
if test -n (type powerline-daemon)
    powerline-daemon -q &
end

# vim {{{2
# Set vim compat if SSH (until there's a better way)
if test -n "$SSH_CONNECTION"
    set -gx VIM_SSH_COMPAT 1
end
# WSL {{{2
# Fix umask env variable if WSL didn't set it properly.
if test -f /proc/version && grep -q "Microsoft" /proc/version
  # https://github.com/Microsoft/WSL/issues/352
  if test (umask) -eq "000" && umask "0022"
  end
end

# END CONFIG {{{1
# Print config.fish load time {{{2
set -l end_time (get_date)
set -l elapsed (math \($end_time - $start_time\))
echo "Completed in $elapsed sec."
set_color brblue; echo 'Done'; set_color normal

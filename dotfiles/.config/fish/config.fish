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

# ENVIRONMENT {{{1
# General System {{{2
set -gx XDG_CACHE_HOME "$HOME/.cache"                           # Standard cache location
set -gx XDG_CONFIG_HOME "$HOME/.config"                         # Standard config location
set -gx XDG_DATA_HOME  "$HOME/.local/share"                     # Standard data location
set -gx LC_ALL 'en_US.UTF-8'                                    # Default encoding
set -gx BROWSER 'w3m'                                           # Text-based browser

# Preferences {{{2
set -gx CLICOLOR 1                                              # Use colors in prompt
set -gx NERD_FONTS 1                                            # Tells Vim which glyphs to use
set -gx LS_AFTER_CD 1                                           # Use snippet in conf.d to echo after cd

# Path {{{2
# Add general PATH items needed here
# Fish 3.0 will ignore invalid dirs, so no need to test
set -p PATH "$HOME/bin"                                         # General user binaries
set -p PATH "$HOME/git/python/shell"                            # Shell-like features using Python

# Fix umask env variable if WSL didn't set it properly.
if test -f /proc/version && grep -q "Microsoft" /proc/version
  # https://github.com/Microsoft/WSL/issues/352
  if test (umask) -eq "000" && umask "0022"
  end
end

# Fish {{{2
set -gx FISH_PKG_MGR "FUNDLE"                                   # Set this here to make things easier
set -gx FISH_PLUGIN_PATH "$XDG_DATA_HOME/fish_plugins"          # Manual plugin install dir
var FISH_THEME "yimmy"                                          # Theme to use if no local univar set
var FISH_SSH_THEME "yimmy"                                      # SSH theme to use if no local univar set

# SSH: get theme if specified {{{3
# if test -n "$SSH_CONNECTION" && set -q FISH_SSH_THEME
#     echo "SSH connection detected! Setting $FISH_SSH_THEME theme... "
#     set FISH_THEME "$FISH_SSH_THEME"
# end

# Load local themes from file {{{3
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


# Python {{{2
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1                            # Disable default venv prompt
set -gx VENV_DIR "$HOME/.env"                                   # Venv directory

# Set and activate default VENV
set -l def_venv "$VENV_DIR/dev/bin/activate.fish"
source $def_venv                                                # Activate by default

# Editor (Vim/Neovim) {{{2
var EDITOR nvim                                                 # Default editor
var VISUAL $EDITOR                                              # Default visual editor
set -gx NVIM_PY2_DIR "$HOME/.env/nvim2/bin/python"
set -gx NVIM_PY3_DIR "$HOME/.env/nvim3/bin/python"
set -gx VIM_SSH_COMPAT 0                                        # Safe term bg in vim

# Vim/Neovim color schemes
set -gx VIM_COLOR PaperColor-dark
set -gx NVIM_COLOR $VIM_COLOR

# Fuzzy Finder (fzf) {{{2
# Enable fuzzy directory finding
set -gx FZF_TMUX 1
set -gx FZF_TMUX_HEIGHT '30%'
set -gx FZF_LEGACY_KEYBINDINGS 0

# Install fzf
if ! test -d "$HOME/.fzf"
    echo "fzf dir not found. Cloning fzf and installing..."
    command git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --bin --no-update-rc
else if not type -q fzf
    echo "fzf dir found, but not installed. Installing..."
    ~/.fzf/install --bin --no-update-rc
end

# Node Version Manager (nvm) {{{2
# nvm
if not test -d "$HOME/.nvm"
    echo "nvm not found. Cloning nvm..."
    command git clone https://github.com/creationix/nvm.git "$HOME/.nvm"
    cd "$HOME/.nvm"
    command git checkout (command git describe --abbrev=0 --tags --match "v[0-9]*" (git rev-list --tags --max-count=1))
end

# Put node binaries in PATH if not already
if not test (type -q node)
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

# Todo.txt {{{2
set -gx TODOTXT_CFG_FILE "$HOME/Dropbox/todo/todo.cfg"

# Go {{{2
# Add go dirs to PATH
set -a PATH "/usr/local/go/bin"                                 # golang binaries
set -a PATH "$HOME/go/bin"                                      # go home dir

# PACKAGES {{{1
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
# Local/SSH theme {{{2
test -z "$FISH_PKG_MGR"
and _loadtheme $FISH_THEME

# Set options based on ssh connection/term size
if test -n "$SSH_CONNECTION" -a "$COLUMNS" -lt 140 -a -z "$TMUX"
    # We're *probably* connecting from iOS
    # Better to use TMUX and name session 'ios'
    set NERD_FONTS 0
end

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

# ABBREVIATIONS {{{1
# Misc Apps {{{2
ab xo xonsh                                                     # Open xonsh shell
ab lp lpass                                                     # LastPass cli
ab vcp 'vcprompt -f "%b %r %p %u %m"'                           # Fast git status
ab vw view                                                      # Call view function (vim read-only)
ab o omf                                                        # oh-my-fish
ab z j                                                          # Use autojump (j) instead of z

# Git {{{2
ab g 'git'
ab ga 'git add'                                                 # Stage specific files
ab gac 'git add . && git commit'                                # Combine add + commit
ab gc 'git commit'                                              # Commit staged files
ab gco 'git checkout master'                                    # Overwrite local files with master
ab gcp 'git commit; and git push'                               # Combine commit + push
ab gcol 'git checkout (git describe --tags)'                    # Check out latest tag
ab gd 'git diff'
ab gdf 'git diff'
ab gdiff 'git diff'
ab gpl 'git pull'
ab gph 'git push'
ab gs 'git show'
ab gst 'git status -s'
ab glog 'vim +GV'                                               # Open interactive git log in vim
ab grst 'git reset --hard origin/master'                        # Overwrite local repo with remote
ab gsub 'git submodule foreach --recursive git pull origin master' # Update all submodules
ab gsync 'git pull && git add . && git commit && git push'      # Sync local repo
ab gunst 'git reset HEAD'                                       # Unstage file
ab grmi 'git rm --cached'                                       # Remove from index but keep local

# Directories {{{2
ab - cd
ab p fzf_cdhist
ab lla 'ls -la'
ab ftpl "$HOME/.vim/after/ftplugin"
ab h $HOME
ab dot "$HOME/dotfiles/dotfiles"
ab vdot "$HOME/dotfiles/dotfiles/.vim"
ab gdot "$HOME/dotfiles/dotfiles"
ab gpy "$HOME/git/python"
ab gpython "$HOME/git/python"
ab pd prevd
ab nd nextd
ab rmdir 'rm -rf'
ab vico "$HOME/.vim/config"

# Fish {{{2
# Commands {{{3
ab frel 'exec fish'                                             # Reload fish shell in place
ab frec 'clear; and exec fish'                                  # Clear terminal and reload fish shell in place
ab funced 'funced -s'                                           # Edit function + save to disk
ab cm 'command'                                                 # Use command directly (like \ in bash)
ab fcf "vim $__fish_config_dir/config.fish"                     # Edit config.fish
ab del 'history delete'                                         # Deletes history matching pattern
ab dlast 'history delete $history[1] --exact --case-sensitive'  # Delete last history item

# Dirs {{{3
ab fc "$__fish_config_dir"                                      # Fish config home
ab ffn "$__fish_config_dir/functions"                           # Fish user functions directory
ab fcm "$__fish_config_dir/completions"                         # Fish user completions directory
ab fcd "$__fish_config_dir/conf.d"                              # Fish user configuration snippets

# FZF {{{3
ab fp "fzf-tmux --reverse --preview 'cat {} --color=always'"   # fzf with colorized preview window

# Python {{{2
ab pysh "$HOME/git/python/shell"                              # Python shell scripts
ab denv "source $def_venv"                                    # Activate venv
ab pr 'powerline-daemon --replace'                            # Reload powerline

# Scripts {{{2
ab l list
ab lso 'list -hO'
ab listd 'list --debug'
ab listh 'list --help'

# TMux {{{2
ab te "vim $HOME/.tmux.conf && tmux source ~/.tmux.conf && tmux display '~/.tmux.conf sourced'"
ab tl 'tmux ls'

# Todo.txt {{{2
ab t todo                                                       # Todo.txt cli
ab tp topydo                                                    # Todo.txt Python cli

# Vim/Neovim {{{2
ab v vim                                                        # Call vim function (Open Neovim || Vim)
ab vf 'vim (fzf)'                                               # Find file to open
ab n nvim                                                       # Call Neovim directly
ab nv nvim                                                      # Another Neovim
ab vvim 'command vim'                                           # Call Vim binary directly
ab vv 'command vim'                                             # Call Vim directly

# System {{{2
ab che 'chmod +x'                                               # Make executable
ab chr 'chmod 755'                                              # 'Reset' permission in WSL
ab version 'cat /etc/os-release'                                # Print Linux version info
ab q exit                                                       # One key
ab x exit                                                       # One key
ab quit exit                                                    # Just in case I forget which :)
ab path 'set -S PATH'                                           # Print PATH array
ab lookbusy 'cat /dev/urandom | hexdump -C | grep --color "ca fe"'
ab mntp 'sudo mount -t drvfs P: /mnt/p'                         # Mount P: drive (could be local to io)

# KEYBINDINGS {{{1
# vi-mode with custom keybindings {{{2
# set fish_key_bindings fish_user_vi_key_bindings

# END CONFIG {{{1
# Print config.fish load time {{{2
set -l end_time (get_date)
set -l elapsed (math \($end_time - $start_time\))
echo "Completed in $elapsed sec."
set_color brblue; echo 'Done'; set_color normal

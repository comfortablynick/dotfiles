#!/usr/bin/env fish
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

# SHELL STARTUP ============================= {{{
if not status --is-interactive
  exit 0
end

# Everything below is for interactive shells
# _logo
set_color $fish_color_autosuggestion;
set -l start_time (get_date)
echo -n 'Sourcing config.fish...  '
# }}}
# ENVIRONMENT =============================== {{{
# General System {{{
set -gx XDG_CONFIG_HOME "$HOME/.config"                         # Standard config location
set -gx XDG_DATA_HOME  "$HOME/.local/share"                     # Standard data location
set -gx LC_ALL 'en_US.UTF-8'                                    # Default encoding
set -gx CLICOLOR 1                                              # Use colors in prompt
# set -gx POWERLINE_ROOT /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/powerline
set -gx NERD_FONTS 1
# }}}
# PATH {{{
# Add any PATH items needed here
# Fish 3.0 will ignore invalid dirs, so no need to test
set -p PATH "$HOME/bin"                                         # General user binaries
set -p PATH "$HOME/git/python/shell"                            # Shell-like features using Python

# Fix umask env variable if WSL didn't set it properly.
if test -f /proc/version && grep -q "Microsoft" /proc/version
  # https://github.com/Microsoft/WSL/issues/352
  if test (umask) -eq "000" && umask "0022"
  end
end
# }}}
# Fish {{{
set -gx FISH_PKG_MGR "FUNDLE"                                   # Set this here to make things easier
set -gx FISH_PLUGIN_PATH "$XDG_DATA_HOME/fish_plugins"          # Manual plugin install dir
set -gx FISH_THEME "yimmy"
set -gx FISH_SSH_THEME "yimmy"

# Get theme from local file
if test -f $XDG_DATA_HOME/fish/theme
    read local_theme < $XDG_DATA_HOME/fish/theme
    set FISH_THEME $local_theme
end

# Get ssh theme from local file
if test -f $XDG_DATA_HOME/fish/ssh_theme
    read local_ssh_theme < $XDG_DATA_HOME/fish/ssh_theme
    set FISH_SSH_THEME $local_ssh_theme
end
# }}}
# Python {{{
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1                            # Disable default venv prompt
set -gx VENV_DIR "$HOME/.env"                                   # Venv directory
# }}}
# Editor {{{
set -gx EDITOR nvim                                             # Default editor
set -gx VISUAL $EDITOR                                          # Default visual editor
set -gx NVIM_PY2_DIR "$VENV_DIR/nvim2"                          # Python 2 path for Neovim
set -gx NVIM_PY3_DIR "$VENV_DIR/nvim3"                          # Python 3 path for Neovim
set -gx VIM_SSH_COMPAT 0                                        # Safe term bg in vim

# Vim/Neovim color schemes
set -gx VIM_COLOR gruvbox-dark
set -gx NVIM_COLOR gruvbox-dark
# }}}
# Fuzzy Finder (fzf) {{{
# Enable fuzzy directory finding
set -gx FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"

# Install fzf
if ! test -d "$HOME/.fzf"
    echo "fzf dir not found. Cloning fzf and installing..."
    command git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --bin --no-update-rc
else if not type -q fzf
    echo "fzf dir found, but not installed. Installing..."
    ~/.fzf/install --bin --no-update-rc
end
# }}}
# Node Version Manager (nvm) {{{
# nvm
if ! test -d "$HOME/.nvm"
    echo "nvm not found. Cloning nvm..."
    command git clone https://github.com/creationix/nvm.git "$HOME/.nvm"
    cd "$HOME/.nvm"
    command git checkout (command git describe --abbrev=0 --tags --match "v[0-9]*" (git rev-list --tags --max-count=1))
end
# }}}
# TMux {{{
# Attach to existing tmux or create a new session using custom function
# Get current session name
if test -n "$TMUX_PANE"
    set -gx TMUX_SESSION (tmux list-panes -t "$TMUX_PANE" -F '#S' | head -n1)
    test "$TMUX_SESSION" = 'ios' && set NERD_FONTS 0
end
# }}}
# Powerline {{{
# Start powerline-daemon in bg if it exists
if test -n (type powerline-daemon)
    powerline-daemon -q &
end

# Store root directory for each system (doesn't seem to be needed)
# set -l pl_dirs
# set -a pl_dirs "/usr/local/lib/python3.7/site-packages/powerline"
# set -a pl_dirs "/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/powerline"
#
# # Loop and make sure it exists
# for p in $pl_dirs
#     if test -d $p
#         set -gx POWERLINE_ROOT $p
#         powerline-daemon -q
#         break
#     end
# end
#}}}
# }}}
# FUNCTIONS ================================= {{{
# Need to be defined early if used in config.fish

# ab :: wrap `abbr` so fish linter doesn't complain
function ab -d "create global abbreviation"
    set -l abbrev $argv[1]
    set -l cmd $argv[2..-1]
    abbr -g $abbrev $cmd
end

# j :: alias for __fzf_autojump
function j; __fzf_autojump $argv; end

# aliases to silence config.fish "errors"
function fun; fundle $argv; end
function _loadtheme; loadtheme $argv; end
# }}}
# PACKAGES ================================== {{{
# Package manager setup {{{
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
# }}}
# Plugins {{{
if test -n "$SSH_CONNECTION" && set -q FISH_SSH_THEME
    echo "SSH connection detected! Setting $FISH_SSH_THEME theme... "
    set FISH_THEME $FISH_SSH_THEME
end
# <--- All plugin definitions after this line

# Themes
fun plugin 'comfortablynick/theme-bobthefish' \
    --cond='[ $FISH_THEME = bobthefish ]'
fun plugin 'oh-my-fish/theme-yimmy' --cond='[ $FISH_THEME = yimmy ]'
fun plugin 'rafaelrinaldi/pure' --cond='[ $FISH_THEME = pure ]'

fun plugin 'fisherman/git_util' --cond='[ $FISH_THEME = bigfish ]'
fun plugin 'nyarly/fish-lookup' --cond='[ $FISH_THEME = bigfish ]'
fun plugin 'decors/fish-colored-man'
fun plugin 'jethrokuan/fzf' --c='[ echo (type -q fzf) ]'

# Node.js
fun plugin 'FabioAntunes/fish-nvm'
fun plugin 'edc/bass'

# Test
fun plugin 'fisherman/getopts' --cond 'test 1 -eq 2'
# fundle 'fisherman/getopts', if:'test 1 -eq 1', from:'gh'

# <--- All plugin definitions before this line
fun init
# }}}
# }}}
# SOURCE ==================================== {{{
# set -l externals                                                # Add exteral scripts to this variable
# set -a externals "{PATH TO SCRIPT}"                             # Append to externals variable
# Source external scripts if they exist
# for e in $externals
#   if test -e $e
#     source $e
#   end
# end
# }}}
# THEMES ==================================== {{{
# Local/SSH theme {{{
if test -z "$FISH_PKG_MGR"
  if test -n "$SSH_CONNECTION" && set -q FISH_SSH_THEME
    echo "SSH connection detected! Setting $FISH_SSH_THEME theme... "
    _loadtheme $FISH_SSH_THEME
  else if test -n "$FISH_THEME"
    _loadtheme $FISH_THEME
  end
end

# Set options based on ssh connection/term size
if test -n "$SSH_CONNECTION"; and test "$COLUMNS" -lt 140
    # We're probably connecting from iOS
    set NERD_FONTS 0
end

# }}}
# Git prompt {{{
set -g __fish_git_prompt_show_informative_status true
set -g __fish_git_prompt_showcolorhints true
set -g ___fish_git_prompt_char_stagedstate ±
set -g ___fish_git_prompt_char_stashstate ≡
# }}}
# bobthefish {{{
if test "$FISH_THEME" = 'bobthefish'
    # Set options if term windows is narrow-ish
    if test "$COLUMNS" -lt 140
      set -g theme_newline_cursor yes
      set -g theme_display_date no
    else
      set -g theme_newline_cursor no
      set -g theme_display_date yes
    end

    # Tmux shows user/host, so we dont need it here
    if test -n "$TMUX"
        set -g theme_display_date no
        set -g theme_display_user no
        set -g theme_display_hostname no
        set -g theme_newline_cursor yes
    end
end
# }}}
# Pure Prompt {{{
# Prompt text
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
    set pure_user_host_location 1                                   # Loc of u@h; 0 = end, 1 = beg
    set pure_separate_prompt_on_error 0                             # Show addl char if error
    set pure_command_max_exec_time 5                                # Time elapsed before exec time shown
end
# }}}
# bigfish {{{
set -gx glyph_git_on_branch '🜉'
set -gx glyph_bg_jobs '⚒'
# }}}
# Yimmy {{{
if test "$FISH_THEME" = 'yimmy'
    set -g yimmy_solarized false                                    # Solarized color scheme
end
# }}}
# }}}
# COLORS ==================================== {{{
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
set -g fish_key_bindings fish_default_key_bindings
set -g fish_pager_color_completion
set -g fish_pager_color_description 'b3a06d'  'yellow'
set -g fish_pager_color_prefix 'white'  '--bold'  '--underline'
set -g fish_pager_color_progress 'brwhite'  '--background=cyan'
# }}}
# ABBREVIATIONS ============================= {{{
# Apps {{{
ab xo xonsh                                                   # Open xonsh shell
# ab f fzf                                                      # Fuzzy finder
ab lp lpass                                                   # LastPass cli
ab vcp 'vcprompt -f "%b %r %p %u %m"'                         # Fast git status
ab v vim                                                      # Call vim function (Open Neovim || Vim)
ab n nvim                                                     # Call Neovim directly
ab nv nvim                                                    # Another Neovim
ab vvim 'command vim'                                         # Call Vim binary directly
ab vw view                                                    # Call view function (vim read-only)
ab o omf                                                      # oh-my-fish
ab z j                                                        # Use autojump (j) instead of z
# }}}
# Git {{{
ab g 'git'
ab ga 'git add'
ab gc 'git commit'
ab gco 'git checkout master'
ab gd 'git diff'
ab gdf 'git diff'
ab gdiff 'git diff'
ab gpl 'git pull'
ab gph 'git push'
ab gs 'git show'
ab gst 'git status'
ab glog 'vim +GV'                                             # Open interactive git log in vim
ab grst 'git reset --hard origin/master'                      # Overwrite local repo with remote
ab gsub 'git submodule foreach --recursive git pull origin master'
ab gsync 'git pull && git commit -a && git push'              # Sync local repo
ab gunst 'git reset HEAD'                                     # Unstage file
ab grmi 'git rm --cached'                                     # Remove from index but keep local
# }}}
# Directories {{{
ab - cd
ab lla ls -la
ab h $HOME
ab dot "$HOME/dotfiles/dotfiles"
ab vdot "$HOME/dotfiles/dotfiles/.vim"
ab gdot "$HOME/dotfiles/dotfiles"
ab gpy "$HOME/git/python"
ab gpython "$HOME/git/python"
ab pd prevd
ab nd nextd
ab rmdir rm -rf
# }}}
# Fish {{{
ab frel "exec fish"                                           # Better way to reload?
ab fc "$__fish_config_dir"                                    # Fish config home
ab ffn "$__fish_config_dir/functions"                         # Fish functions directory
ab funced 'funced -s'                                         # Save function after editing automatically
ab fcf "vim $__fish_config_dir/config.fish"                   # Edit config.fish
ab cm 'command'                                               # Instead of \ bash
# }}}
# Python {{{
ab pysh "$HOME/git/python/shell"                              # Python shell scripts
ab denv "source $VENV_DIR/dev/bin/activate.fish"              # Default venv
source "$VENV_DIR/dev/bin/activate.fish"                        # Activate by default
ab pr 'powerline-daemon --replace'                            # Reload powerline
# }}}
# Scripts {{{
ab l list
ab lso 'list -hO'
ab listd 'list --debug'
ab listh 'list --help'
# }}}
# TMux {{{
ab te "vim $HOME/.tmux.conf && tmux source ~/.tmux.conf && tmux display '~/.tmux.conf sourced'"
# }}}
# System {{{
ab che 'chmod +x'                                             # Make executable
ab chr 'chmod 755'                                            # 'Reset' permission in WSL
ab version 'cat /etc/os-release'                              # Print Linux version info
ab q exit                                                     # One key
ab x exit                                                     # One key
ab quit exit                                                  # Just in case I forget which :)
ab path 'set -S PATH'                                         # Print PATH array
ab lookbusy 'cat /dev/urandom | hexdump -C | grep --color "ca fe"'
# }}}
# }}}
# KEYBINDINGS =============================== {{{
# vi-mode with custom keybindings
# set fish_key_bindings fish_user_vi_key_bindings
# }}}
# END CONFIG ================================ {{{
set -l end_time (get_date)
set -l elapsed (math \($end_time - $start_time\))
echo "Completed in $elapsed sec."
set_color brblue; echo 'Done'; set_color normal
# }}}

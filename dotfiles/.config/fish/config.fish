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
# System {{{
set -gx XDG_CONFIG_HOME "$HOME/.config"                         # Standard config location
set -gx XDG_DATA_HOME  "$HOME/.local/share"                     # Standard data location
set -gx LC_ALL 'en_US.UTF-8'                                    # Default encoding
set -gx CLICOLOR 1                                              # Use colors in prompt
set -gx POWERLINE_ROOT /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/powerline
# }}}
# Path {{{
set -l paths                                                    # User path variable; add any paths to this
set -a paths "$HOME/bin"                                        # General user binaries
set -a paths "$HOME/git/python/shell"                           # Shell-like features using Python
# Prepend to $PATH if valid directory
for p in $paths
  if test -d $p
    set PATH $p $PATH
  end
end

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
    echo "Local theme is: $local_theme"
    set FISH_THEME $local_theme
end
# }}}
# Python {{{
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1                            # Disable default venv prompt
set -gx VENV_DIR "$HOME/.env"                                   # Venv directory
# }}}
# Editor {{{
set -gx EDITOR 'vim'                                           # Default editor
set -gx VISUAL $EDITOR                                          # Default visual editor
set -gx NVIM_PY2_DIR "$VENV_DIR/nvim2"                          # Python 2 path for Neovim
set -gx NVIM_PY3_DIR "$VENV_DIR/nvim3"                          # Python 3 path for Neovim
# }}}
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
switch "$FISH_THEMEXXX"
    case "bobthefish"
        fundle plugin 'oh-my-fish/theme-bobthefish'
    case "bigfish"
        fundle plugin 'stefanmaric/bigfish'
    case "pure"
        fundle plugin 'rafaelrinaldi/pure'
    case "yimmy"
        fundle plugin 'oh-my-fish/theme-yimmy'
    case "*"
end
fundle plugin 'oh-my-fish/theme-bobthefish' --cond 'test $FISH_THEME = bobthefish'
fundle plugin 'oh-my-fish/yimmy' --cond 'test $FISH_THEME = yimmy'
fundle plugin 'fisherman/git_util'
fundle plugin 'nyarly/fish-lookup'
fundle plugin 'decors/fish-colored-man'
fundle plugin 'jethrokuan/fzf'
fundle plugin 'fisherman/getopts' --cond 'test 1 -eq 2'
# <--- All plugin definitions before this line
fundle init
# }}}
# System-wide {{{
# fzf
if ! test -d "$HOME/.fzf"
    echo "fzf dir not found. Cloning fzf and installing..."
    command git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --bin --no-update-rc
end
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
if test -z "$FISH_PKG_MGR"
  source $__fish_config_dir/functions/loadtheme.fish
  if test -n "$SSH_CONNECTION" && set -q FISH_SSH_THEME
    echo "SSH connection detected! Setting $FISH_SSH_THEME theme... "
    loadtheme $FISH_SSH_THEME
  else if test -n "$FISH_THEME"
    loadtheme $FISH_THEME
  end
end
# Git prompt {{{
set -g __fish_git_prompt_show_informative_status true
set -g __fish_git_prompt_showcolorhints true
set -g ___fish_git_prompt_char_stagedstate ±
set -g ___fish_git_prompt_char_stashstate ≡
# }}}
# bobthefish {{{
# Set options based on ssh connection/term size
if test -n "$SSH_CONNECTION"
  set -g theme_nerd_fonts no
else
  set -g theme_nerd_fonts yes
end

# Set options if term windows is narrow-ish
if test "$COLUMNS" -lt 100
  set -g theme_newline_cursor yes
  set -g theme_display_date no
else
  set -g theme_newline_cursor no
  set -g theme_display_date yes
end
# }}}
# Pure Prompt {{{
# Prompt text
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
set pure_separate_prompt_on_error 0                             # Show add'l char if error
set pure_command_max_exec_time 5                                # Time elapsed before exec time shown
# }}}
# bigfish {{{
set -gx glyph_git_on_branch '🜉'
set -gx glyph_bg_jobs '⚒'
# }}}
# Yimmy {{{
set -g yimmy_solarized false                                    # Solarized color scheme
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
# FUNCTIONS ================================= {{{
# }}}
# ABBREVIATIONS ============================= {{{
# Apps {{{
abbr -g xo xonsh                                                   # Open xonsh shell
abbr -g vcp 'vcprompt -f "%b %r %p %u %m"'                         # Fast git status
abbr -g v vim                                                      # Call vim function (Open Neovim || Vim)
abbr -g vvim 'command vim'                                         # Call Vim binary directly
abbr -g vw view                                                    # Call view function (vim read-only)
abbr -g o omf                                                      # oh-my-fish
abbr -g z j                                                        # Use autojump (j) instead of z
# }}}
# Git {{{
abbr -g g 'git'
abbr -g ga 'git add'
abbr -g gc 'git commit'
abbr -g gd 'git diff --color-moved=default'
abbr -g gdf 'git diff --color-moved=default'
abbr -g gdiff 'git diff --color-moved=default'
abbr -g gpl 'git pull'
abbr -g gph 'git push'
abbr -g gs 'git show --color-moved=default'
abbr -g gst 'git status'
abbr -g glog 'vim +GV'                                             # Open interactive git log in vim
abbr -g grst 'git reset --hard origin/master'                      # Overwrite local repo with remote
abbr -g gsub 'git submodule foreach --recursive git pull origin master'
abbr -g gsync 'git pull && git commit -a && git push'              # Sync local repo
abbr -g gunst 'git reset HEAD'                                     # Unstage file
abbr -g grmi 'git rm --cached'                                     # Remove from index but keep local
# }}}
# Directories {{{
abbr -g - cd
abbr -g lla ls -la
abbr -g h $HOME
abbr -g dot "$HOME/dotfiles/dotfiles"
abbr -g vdot "$HOME/dotfiles/dotfiles/.vim"
abbr -g gdot "$HOME/dotfiles/dotfiles"
abbr -g gpy "$HOME/git/python"
abbr -g gpython "$HOME/git/python"
abbr -g pd prevd
abbr -g nd nextd
abbr -g rmdir rm -rf
# }}}
# Fish {{{
abbr -g frel "exec fish"                                           # Better way to reload?
abbr -g fc "$__fish_config_dir"                                    # Fish config home
abbr -g ffn "$__fish_config_dir/functions"                         # Fish functions directory
abbr -g funced 'funced -s'                                         # Save function after editing automatically
abbr -g fcf "vim $__fish_config_dir/config.fish"                   # Edit config.fish
abbr -g cm 'command'                                               # Fish has no '\' shortcut for `command`
# }}}
# Python {{{
abbr -g pysh "$HOME/git/python/shell"                              # Python shell scripts
abbr -g denv "source $VENV_DIR/dev/bin/activate.fish"              # Default venv
source "$VENV_DIR/dev/bin/activate.fish"                        # Activate by default
# }}}
# Scripts {{{
abbr -g l list
abbr -g lso 'list -hO'
abbr -g listd 'list --debug'
abbr -g listh 'list --help'
# }}}
# System {{{
abbr -g che 'chmod +x'                                             # Make executable
abbr -g chr 'chmod 755'                                            # 'Reset' permission in WSL
abbr -g version 'cat /etc/os-release'                              # Print Linux version info
abbr -g q exit                                                     # One key
abbr -g x exit                                                     # One key
abbr -g quit exit                                                  # Just in case I forget which :)
abbr -g path 'set -S PATH'                                         # Print PATH array
abbr -g lookbusy 'cat /dev/urandom | hexdump -C | grep --color "ca fe"'
# }}}
# }}}
# ALIASES =================================== {{{
alias git "hub"
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

#                  ___
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

set_color $fish_color_autosuggestion; echo -n 'Sourcing config.fish...  '

# ENVIRONMENT VARIABLES =========================
# System
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x LC_ALL 'en_US.UTF-8'
set -x POWERLINE_ROOT /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/powerline
set -gx CLICOLOR 1
# set -gx LSCOLORS (dircolors -c "$HOME/.dircolors" | string split ' ')[3]

# WSL (Windows Subsystem for Linux) Fixes
if test -f /proc/version && grep -q "Microsoft" /proc/version

  # Fix umask value if WSL didn't set it properly.
  # https://github.com/Microsoft/WSL/issues/352
  if test (umask) -eq "000" && umask 022

  end
end

# Text editor
set -x EDITOR 'nvim'
set -x VISUAL $EDITOR

# Python Venv
set -x VIRTUAL_ENV_DISABLE_PROMPT 1                             # Default venv prompt doesn't like fish
set -x VENV_DIR "$HOME/.env"

# Vim/Neovim
set -x NVIM_PY2_DIR "$VENV_DIR/nvim2"
set -x NVIM_PY3_DIR "$VENV_DIR/nvim3"

# Fish Theme
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

set -g h_color_autosuggestion 969896
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
set -g fish_greeting /c/users/nmurphy/.config/fish/functions/_logo.fish
set -g fish_key_bindings fish_default_key_bindings
set -g fish_pager_color_completion
set -g fish_pager_color_description 'b3a06d'  'yellow'
set -g fish_pager_color_prefix 'white'  '--bold'  '--underline'
set -g fish_pager_color_progress 'brwhite'  '--background=cyan'


# abbreviations =================================
# Apps
abbr xo xonsh                                                   # Open xonsh shell
abbr v vim                                                      # Call vim function (Open Neovim || Vim)
abbr vvim 'command vim'                                         # Call Vim binary directly

# Git
abbr g 'git'
abbr ga 'git add'
abbr gc 'git commit'
abbr gd 'git diff'
abbr gdf 'git diff'
abbr gdiff 'git diff'
abbr gpl 'git pull'
abbr gph 'git push'
abbr gst 'git status'
abbr glog 'vim +GV'                                             # Open interactive git log in vim
abbr gsub 'git submodule foreach --recursive git pull origin master'
abbr gsync 'git pull; git add .; git commit; git push'          # Replace with real function eventually

# Directories
abbr l ls
abbr h $HOME
abbr dot "$HOME/dotfiles/dotfiles"
abbr vdot "$HOME/dotfiles/dotfiles/.vim"
abbr gdot "$HOME/dotfiles/dotfiles"
abbr gpy "$HOME/git/python"
abbr pd prevd
abbr nd nextd
abbr rmdir rm -rf

# Fish 
abbr fc "$XDG_CONFIG_HOME/fish"                                 # Fish config home
abbr ffn "$fish_function_path[1]"                               # Fish functions directory
abbr funced 'funced -is'                                        # Open commandline editor and save function after
abbr fcf "vim $XDG_CONFIG_HOME/fish/config.fish"                # Edit config.fish
abbr cm 'command'                                               # Fish has no '\' shortcut for `command`

# Python
abbr pysh "$HOME/git/python/shell"                           # Python shell scripts
abbr denv "source $VENV_DIR/dev/bin/activate.fish"              # Default venv
source "$VENV_DIR/dev/bin/activate.fish"                        # Activate by default

# System
abbr q exit
abbr x exit
abbr quit exit

# Pure Prompt {{{

# Change the prompt text
# set pure_symbol_prompt "~>"
# set pure_symbol_git_down_arrow "v"
# set pure_symbol_git_up_arrow "^"
# set pure_symbol_git_dirty "!"
# set pure_symbol_horizontal_bar "_"

# Change the colors
set pure_color_blue (set_color "1e00fd")
set pure_color_cyan (set_color "1e95fd")
set pure_color_gray (set_color "6c6c6c")
set pure_color_green (set_color "66ff66")
set pure_color_normal (set_color "000000")
set pure_color_red (set_color "f820ff")
set pure_color_yellow (set_color "1bc8c8")

# Change colors for username and host in SSH
set pure_username_color $pure_color_yellow
set pure_host_color $pure_color_green
set pure_root_color $pure_color_red

# Change where the username and host is displayed
# 0 - end of prompt, default
# 1 - start of prompt
set pure_user_host_location 0

# Show exit code of last command as a separate prompt character. As described
# here:
# https://github.com/sindresorhus/pure/wiki#show-exit-code-of-last-command-as-a-separate-prompt-character
# 0 - single prompt character, default
# 1 - separate prompt character
# Any other value defaults to the default behaviour
# set pure_separate_prompt_on_error 1

# Max execution time of a process before its run time is shown when it exits
# set pure_command_max_exec_time 5
# }}}

# Load event functions
source "$XDG_CONFIG_HOME/fish/functions/on_exit.fish"

set_color brblue; echo 'Done'
set_color normal

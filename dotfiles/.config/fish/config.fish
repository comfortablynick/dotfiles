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
## ENVIRONMENT VARIABLES ===================== {{{

# System
set -gx XDG_CONFIG_HOME "$HOME/.config"                         # In case it isn't set
set -gx LC_ALL 'en_US.UTF-8'                                    # Default encoding
set -gx CLICOLOR 1                                              # Use colors in prompt
# set -gx LSCOLORS (dircolors -c "$HOME/.dircolors" | string split ' ')[3]
set -gx POWERLINE_ROOT /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/powerline

# Text editor
set -gx EDITOR 'nvim'                                           # Default editor
set -gx VISUAL $EDITOR                                          # Default visual editor

# Python Venv
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1                            # Default venv prompt doesn't like fish
set -gx VENV_DIR "$HOME/.env"                                   # Venv directory

# Vim/Neovim
set -gx NVIM_PY2_DIR "$VENV_DIR/nvim2"                          # Python 2 path for Neovim
set -gx NVIM_PY3_DIR "$VENV_DIR/nvim3"                          # Python 3 path for Neovim

# }}}
## PACKAGES ================================= {{{

# Oh-My-Fish
# if not functions -q omf
#   echo "OMF not found; installing... "
#   set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME "$HOME/.config"
#   curl -L https://get.oh-my.fish | fish
# end
# }}}
## SOURCE ==================================== {{{
# source "$fish_function_path[1]/on_exit.fish"                    # Have to source rather than autoload
fix_wsl_umask                                                   # Run function to fix umask

# }}}
## THEME / COLOR OPTIONS ===================== {{{
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
# Fish Colors {{{
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
# }}}
# }}}
## ABBREVIATIONS ============================= {{{
# Apps {{{
abbr xo xonsh                                                   # Open xonsh shell
abbr v vim                                                      # Call vim function (Open Neovim || Vim)
abbr vvim 'command vim'                                         # Call Vim binary directly
# }}}
# Git {{{
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
# }}}
# Directories {{{
abbr l ls
abbr lla la -la
abbr h $HOME
abbr dot "$HOME/dotfiles/dotfiles"
abbr vdot "$HOME/dotfiles/dotfiles/.vim"
abbr gdot "$HOME/dotfiles/dotfiles"
abbr gpy "$HOME/git/python"
abbr gpython "$HOME/git/python"
abbr pd prevd
abbr nd nextd
abbr rmdir rm -rf
# }}}
# Fish {{{ 
abbr fc "$XDG_CONFIG_HOME/fish"                                 # Fish config home
abbr ffn "$fish_function_path[1]"                               # Fish functions directory
abbr funced 'funced -is'                                        # Open commandline editor and save function after
abbr fcf "vim $XDG_CONFIG_HOME/fish/config.fish"                # Edit config.fish
abbr cm 'command'                                               # Fish has no '\' shortcut for `command`
# }}}
# Python {{{
abbr pysh "$HOME/git/python/shell"                           # Python shell scripts
abbr denv "source $VENV_DIR/dev/bin/activate.fish"              # Default venv
source "$VENV_DIR/dev/bin/activate.fish"                        # Activate by default
# }}}
# System {{{
abbr che 'chmod +x'
abbr q exit
abbr x exit
abbr quit exit
# }}}
# }}}
set_color brblue; echo 'Done'; set_color normal

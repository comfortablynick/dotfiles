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

# Text editor
set -x EDITOR 'nvim'
set -x VISUAL $EDITOR

# Python Venv
set -x VIRTUAL_ENV_DISABLE_PROMPT 1                             # Default venv prompt doesn't like fish
set -x VENV_DIR "$HOME/.env"

# Vim/Neovim
set -x NVIM_PY2_DIR "$VENV_DIR/nvim2"
set -x NVIM_PY3_DIR "$VENV_DIR/nvim3"


# ABBREVIATIONS =================================
# Apps
abbr xo xonsh                                                   # Open xonsh shell
abbr v vim                                                      # Call vim function (Open Neovim || Vim)
abbr vvim 'command vim'                                         # Call Vim binary directly

# Git
abbr g 'git'
abbr ga 'git add'
abbr gc 'git commit'
abbr gd 'git diff'
abbr gpl 'git pull'
abbr gph 'git push'
abbr gst 'git status'
abbr glog 'vim +GV'                                             # Open interactive git log in vim

# Directories
abbr l ls
abbr h $HOME
abbr dot "$HOME/dotfiles/dotfiles"
abbr vdot "$HOME/dotfiles/dotfiles/.vim"
abbr gdot "$HOME/git/python"
abbr pd prevd
abbr nd nextd

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


set_color brblue; echo 'Done'
set_color normal

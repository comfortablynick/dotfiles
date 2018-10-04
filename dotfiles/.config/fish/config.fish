
set fish_greeting

set -x EDITOR 'nvim'
set -x VISUAL $EDITOR
set -x VIRTUAL_ENV_DISABLE_PROMPT 1                     # Default venv prompt doesn't like fish

# Source foreign shell env variables
fenv source ~/.bashrc

# Set abbreviations
echo -n Setting abbreviations... 

# Apps
alias xo 'xonsh'

# Git
abbr g 'git'
abbr ga 'git add'
abbr gc 'git commit'
abbr gd 'git diff'
abbr gst 'git status'
abbr glog 'vim +GV'

# Directories
abbr dot '~/dotfiles/dotfiles'
abbr vdot '~/dotfiles/dotfiles/.vim'

# Builtins
abbr funced 'funced -is'

echo 'Done'

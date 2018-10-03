
set fish_greeting

set -x EDITOR 'nvim'
set -x VISUAL $EDITOR

# Get bash aliases we want to use for now
source ~/.config/fish/bash_aliases.fish

# Set abbreviations
if not set -q abbrs_initialized
  set -U abbrs_initialized
  echo -n Setting abbreviations...
  
  # Apps
  alias v 'nvim'
  alias vim 'nvim'
  alias xo 'xonsh'

  # Git
  abbr g 'git'
  abbr ga 'git add'
  abbr gc 'git commit'
  abbr gd 'git diff'
  abbr glog 'vim +GV'

  # Directories
  abbr dot '~/dotfiles/dotfiles'

  echo 'Done'
end

# Add general PATH items needed here
# Fish 3.0 will ignore invalid dirs, so no need to test
set -p PATH "$HOME/bin"                                         # General user binaries
set -p PATH "$HOME/git/python/shell"                            # Shell-like features using Python
set -a PATH "/usr/local/go/bin"                                 # golang binaries
set -a PATH "$HOME/go/bin"                                      # go home dir


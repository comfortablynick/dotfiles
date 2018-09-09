#!/usr/bin/env bash
# Helpful bash scripts; loaded by .bashrc

# Adds, commits, and pushes to git with one command
function gsync() {
    # Are we in git branch?
    if [[ ! $git_branch ]]; then 
        echo "Not in a repository."
    else
        # Check for uncommitted changes
        if [[ ! $git_dirty ]]; then
            # No changes; pull
            echo "No uncommitted changes."
            git pull
        else 
            # Commit changes
            echo "Enter commit message:"
            read _cmtmsg

            if [[ ! "$_cmtmsg" ]]; then
                echo "Commit message required! Aborting."
            else
                git add .
                git commit -m "$_cmtmsg"
                git push
                git pull
            fi
        fi
    fi
}

# Displays useful sets of terminal colors based on param input
# either set by default aliases or user-defined... When looking
# for a color theme for a project, bash-colors-random has prooven
# to effortlessly throw some decent color combination.
function bash-colors() {
  local SEQNUM=${1:-4}; [[ "$SEQNUM" -eq "0" ]] && SEQNUM=4;
  tput rmam;
  seq -ws ' ' 0 ${SEQNUM} 256 | \xargs -n1 bash -c \
  'echo -ne "\033[1;48;5;${0}m \\\033[48;5;${0}m \033[0m"; \
  echo -ne "\033[1;7;38;5;${0}m\\\033[7;38;5;${0}m \033[0m"; \
  echo -ne " \033[1;38;5;${0}m\\\033[1;38;5;${0}m\033[0m"; \
  echo -ne " \033[38;5;${0}m\\\033[38;5;${0}m\033[0m"; \
  echo -ne " \033[2;38;5;${0}m\\\033[2;38;5;${0}m\033[0m"; \
  echo -ne " \033[3;38;5;${0}m\\\033[3;38;5;${0}m\033[0m"; \
  echo -ne " \033[4;38;5;${0}m\\\033[4;38;5;${0}m\033[0m"; \
  echo -ne " \033[9;38;5;${0}m\\\033[9;38;5;${0}m\033[0m"; \
  echo -ne " \033[4;9;38;5;${0}m\\\033[4;9;38;5;${0}m\033[0m"; \
  echo -e " \033[1;3;4;9;38;5;${0}m\\\033[1;3;4;9;38;5;${0}m\033[0m"';
  tput smam;
}
alias bash-colors-full='bash-colors 1';
alias bash-colors-minimal='bash-colors 8';
alias bash-colors-less='bash-colors 2';
alias bash-colors-random='bash-colors $(shuf -n1 -i 1-64)';

# Reset the terminal and source .bashrc
function reload(){
    reset
    source ${HOME}/.bashrc
}

# Reset and print elapsed time for debugging
function treload(){
    reset
    if [[ $1 == 'd' ]]; then
        export DEBUG_MODE=true
    else 
        export DEBUG_MODE=false
    fi
    time . "${HOME}/.bashrc"
}

# Easily print timestamp
function timestamp() {
    date +"%T"
}
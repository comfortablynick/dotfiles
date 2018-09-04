#!/usr/bin/env bash
# Helpful bash scripts; loaded by .bashrc

# Debug
[ ${DEBUG} == true ] && echo "Using .bash_functions";

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

# Reset the terminal and source .bashrc
function reload(){
    reset
    source ${HOME}/.bashrc
}
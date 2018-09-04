#!/usr/bin/env bash
# Helpful bash scripts; loaded by .bashrc

# Debug
[ ${DEBUG} == true ] && echo "Using .bash_functions";

# Adds, commits, and pushes to git with one command.
function gitgo() {
    # Are we in a directory under source control?
    if [[ ! -d .git ]]; then
        echo "Not a git repository."
    else
        echo "You are in ${PWD}"
        # Are there any changes that need to be committed?
        if git diff-index --quiet HEAD --; then
            echo "Repository is up to date."
        else                
            # Prompt user for commit message
            echo "Enter commit message:"
            read _msg

            # Was a commit message passed?
            if [[ ! "$_msg" ]]; then
                echo "You must include a commit message."
            else
                git add .
                git commit -m "$_msg"
                git push
            fi
        fi
    fi
}

function gsync() {
# Automate commit, add, push with one command
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

# Reset the terminal
function reload(){
    reset
    source ${HOME}/.bashrc
}
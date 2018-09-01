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


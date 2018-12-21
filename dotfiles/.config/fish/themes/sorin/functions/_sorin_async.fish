#!/usr/bin/env fish

set caller $argv[1]

set -U prompt_sorin_gitprompt_$caller (gitprompt.py)
kill -WINCH $caller

#!/usr/bin/env zsh

echo "${$(dirs)// /\n}" | fzf-tmux

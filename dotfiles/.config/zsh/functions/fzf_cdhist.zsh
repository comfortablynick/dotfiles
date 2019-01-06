#!/usr/bin/env zsh

echo "${$(dirs)// /\n}" | $(__fzfcmd)

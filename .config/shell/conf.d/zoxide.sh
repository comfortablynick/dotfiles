#!/bin/sh
# source zoxide hook
if [ -z "$(command -v zoxide)" ]; then
    return
fi

shell="$(basename "$SHELL")"

eval "$(zoxide init "$shell")"

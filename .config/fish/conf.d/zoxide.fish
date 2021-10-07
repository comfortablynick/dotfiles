# zoxide hook
if command -q zoxide; and status is-interactive
    zoxide init fish | source
end

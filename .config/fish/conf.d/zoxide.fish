# zoxide hook
if type -qf zoxide; and status is-interactive
    zoxide init fish | source
end

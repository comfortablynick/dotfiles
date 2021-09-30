function fish_greeting --description What\'s\ up,\ fish\?
    set_color $fish_color_autosuggestion
    uname -nmsr
    uptime
    set_color normal
end

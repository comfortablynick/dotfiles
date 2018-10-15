function fish_greeting -d "Hello user!"
  _logo
  set_color $fish_color_autosuggestion
  uname -nmsr
  uptime
  set_color normal
end

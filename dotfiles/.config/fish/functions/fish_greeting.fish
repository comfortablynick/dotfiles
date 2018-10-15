# Defined in - @ line 2
function fish_greeting
  _logo                                                         # Execute logo function
  set_color $fish_color_autosuggestion
  uname -nmsr
  uptime
  set_color normal
end

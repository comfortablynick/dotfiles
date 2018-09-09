#!/usr/bin/env bash
# Bash Colors and Formatting
#
# Usage:
#
#   $ source ~/.colors
#   $ echo -e "${norm_yellow}hello, i'm yellow.${reset_color}"
#
# Reference:
#
#   - Bash tips: Colors and formatting <http://misc.flogisoft.com/bash/tip_colors_and_formatting>
 
# reset all attributes
reset_color=$(echo -ne '\033[0m')                  # no color
 
# regular colors
norm_black=$(echo -ne '\033[0;30m')                # black
norm_red=$(echo -ne '\033[0;31m')                  # red
norm_green=$(echo -ne '\033[0;32m')                # green
norm_yellow=$(echo -ne '\033[0;33m')               # yellow
norm_blue=$(echo -ne '\033[0;34m')                 # blue
norm_purple=$(echo -ne '\033[0;35m')               # purple
norm_cyan=$(echo -ne '\033[0;36m')                 # cyan
norm_white=$(echo -ne '\033[0;37m')                # white
 
# bright colors
bright_black=$(echo -ne '\033[0;90m')              # black
bright_red=$(echo -ne '\033[0;91m')                # red
bright_green=$(echo -ne '\033[0;92m')              # green
bright_yellow=$(echo -ne '\033[0;93m')             # yellow
bright_blue=$(echo -ne '\033[0;94m')               # blue
bright_purple=$(echo -ne '\033[0;95m')             # purple
bright_cyan=$(echo -ne '\033[0;96m')               # cyan
bright_white=$(echo -ne '\033[0;97m')              # white
 
# bold colors
bold_black=$(echo -ne '\033[1;30m')                # black
bold_red=$(echo -ne '\033[1;31m')                  # red
bold_green=$(echo -ne '\033[1;32m')                # green
bold_yellow=$(echo -ne '\033[1;33m')               # yellow
bold_blue=$(echo -ne '\033[1;34m')                 # blue
bold_purple=$(echo -ne '\033[1;35m')               # purple
bold_cyan=$(echo -ne '\033[1;36m')                 # cyan
bold_white=$(echo -ne '\033[1;37m')                # white
 
# bright bold colors
bright_bold_black=$(echo -ne '\033[1;90m')         # black
bright_bold_red=$(echo -ne '\033[1;91m')           # red
bright_bold_green=$(echo -ne '\033[1;92m')         # green
bright_bold_yellow=$(echo -ne '\033[1;93m')        # yellow
bright_bold_blue=$(echo -ne '\033[1;94m')          # blue
bright_bold_purple=$(echo -ne '\033[1;95m')        # purple
bright_bold_cyan=$(echo -ne '\033[1;96m')          # cyan
bright_bold_white=$(echo -ne '\033[1;97m')         # white
 
# underline colors
underline_black=$(echo -ne '\033[4;30m')           # black
underline_red=$(echo -ne '\033[4;31m')             # red
underline_green=$(echo -ne '\033[4;32m')           # green
underline_yellow=$(echo -ne '\033[4;33m')          # yellow
underline_blue=$(echo -ne '\033[4;34m')            # blue
underline_purple=$(echo -ne '\033[4;35m')          # purple
underline_cyan=$(echo -ne '\033[4;36m')            # cyan
underline_white=$(echo -ne '\033[4;37m')           # white
 
# background colors
background_black=$(echo -ne '\033[40m')            # black
background_red=$(echo -ne '\033[41m')              # red
background_green=$(echo -ne '\033[42m')            # green
background_yellow=$(echo -ne '\033[43m')           # yellow
background_blue=$(echo -ne '\033[44m')             # blue
background_purple=$(echo -ne '\033[45m')           # purple
background_cyan=$(echo -ne '\033[46m')             # cyan
background_white=$(echo -ne '\033[47m')            # white
 
# bright background colors
background_bright_black=$(echo -ne '\033[0;100m')  # black
background_bright_red=$(echo -ne '\033[0;101m')    # red
background_bright_green=$(echo -ne '\033[0;102m')  # green
background_bright_yellow=$(echo -ne '\033[0;103m') # yellow
background_bright_blue=$(echo -ne '\033[0;104m')   # blue
background_bright_purple=$(echo -ne '\033[10;95m') # purple
background_bright_cyan=$(echo -ne '\033[0;106m')   # cyan
background_bright_white=$(echo -ne '\033[0;107m')  # white
 
# format
format_bold_bright=$(echo -ne '\033[1m')           # bold
format_dim=$(echo -ne '\033[2m')                   # dim
format_underline=$(echo -ne '\033[4m')             # underlined
format_blink=$(echo -ne '\033[5m')                 # blink
format_invert=$(echo -ne '\033[7m')                # invert fg and bg
format_hide=$(echo -ne '\033[8m')                  # hide

return;
# Regular
txtblk="$(tput setaf 0 2>/dev/null || echo '\e[0;30m')"  # Black
txtred="$(tput setaf 1 2>/dev/null || echo '\e[0;31m')"  # Red
txtgrn="$(tput setaf 2 2>/dev/null || echo '\e[0;32m')"  # Green
txtylw="$(tput setaf 3 2>/dev/null || echo '\e[0;33m')"  # Yellow
txtblu="$(tput setaf 4 2>/dev/null || echo '\e[0;34m')"  # Blue
txtpur="$(tput setaf 5 2>/dev/null || echo '\e[0;35m')"  # Purple
txtcyn="$(tput setaf 6 2>/dev/null || echo '\e[0;36m')"  # Cyan
txtwht="$(tput setaf 7 2>/dev/null || echo '\e[0;37m')"  # White

# Bold
bldblk="$(tput setaf 0 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;30m')"  # Black
bldred="$(tput setaf 1 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;31m')"  # Red
bldgrn="$(tput setaf 2 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;32m')"  # Green
bldylw="$(tput setaf 3 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;33m')"  # Yellow
bldblu="$(tput setaf 4 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;34m')"  # Blue
bldpur="$(tput setaf 5 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;35m')"  # Purple
bldcyn="$(tput setaf 6 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;36m')"  # Cyan
bldwht="$(tput setaf 7 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;37m')"  # White

# Underline
undblk="$(tput setaf 0 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;30m')"  # Black
undred="$(tput setaf 1 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;31m')"  # Red
undgrn="$(tput setaf 2 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;32m')"  # Green
undylw="$(tput setaf 3 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;33m')"  # Yellow
undblu="$(tput setaf 4 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;34m')"  # Blue
undpur="$(tput setaf 5 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;35m')"  # Purple
undcyn="$(tput setaf 6 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;36m')"  # Cyan
undwht="$(tput setaf 7 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;37m')"  # White

# Background
bakblk="$(tput setab 0 2>/dev/null || echo '\e[40m')"  # Black
bakred="$(tput setab 1 2>/dev/null || echo '\e[41m')"  # Red
bakgrn="$(tput setab 2 2>/dev/null || echo '\e[42m')"  # Green
bakylw="$(tput setab 3 2>/dev/null || echo '\e[43m')"  # Yellow
bakblu="$(tput setab 4 2>/dev/null || echo '\e[44m')"  # Blue
bakpur="$(tput setab 5 2>/dev/null || echo '\e[45m')"  # Purple
bakcyn="$(tput setab 6 2>/dev/null || echo '\e[46m')"  # Cyan
bakwht="$(tput setab 7 2>/dev/null || echo '\e[47m')"  # White

# Reset
txtrst="$(tput sgr 0 2>/dev/null || echo '\e[0m')"  # Text Reset

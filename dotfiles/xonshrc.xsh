"""xonsh Config File"""
import socket

# Env variables
$HOST = socket.gethostname()
$AUTO_CD = True
$XONSH_SHOW_TRACEBACK = True
$XONSH_AUTOPAIR = True
$VIRTUALENV_HOME = $HOME
$XONSH_COLOR_STYLE = 'default'
$DYNAMIC_CWD_WIDTH = '20%'
$COMPLETIONS_CONFIRM = True
$LANG = "en_US.UTF-8"
$LC_ALL = "en_US.UTF-8"
$MULTILINE_PROMPT = '`·.,¸,.·*¯`·.,¸,.·*¯'

# Aliases
# TODO: source this from a separate file like bash?
aliases['xreload'] = 'source ~/.xonshrc'

# Source bash aliases, etc.
source-bash "echo loading xonsh foreign shell"

# Load xontrib plugins
plugs = ["apt_tabcomplete", "coreutils", "distributed", "jedi", "vox", "vox_tabcomplete", "powerline"]

if $HOST == "joppa":
    del plugs[-1]

for p in plugs:
    xontrib load @(p)

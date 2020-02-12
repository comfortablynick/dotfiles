# Fish completion definition for vimsync.py
#
# Author: Nick Murphy

complete -c vimsync -f -s h -l help    -d 'show help text and exit'
complete -c vimsync -f -s d -l dein    -d 'sync plugins for dein'
complete -c vimsync -f -s p -l plug    -d 'sync plugins for vim-plug'
complete -c vimsync -f -s r -l remote  -d 'update nvim remote plugins'
complete -c vimsync -f -s y -l ycm     -d 'build YouCompleteMe'

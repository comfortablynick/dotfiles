#!/usr/bin/env zsh
#            _
#   ____ ___| |__  _ __ ___
#  |_  // __| '_ \| '__/ __|
#  _/ /_\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|

# NON-INTERACTIVE {{{1
[[ $- != *i* ]] && return                                       # Everything after this line for interactive only

# ENVIRONMENT {{{1
START_TIME="$(date)"

# Check OS
case "$(uname -s)" in
    Linux*)     OS_NAME=Linux;;
    Darwin*)    OS_NAME=Mac;;
    CYGWIN*)    OS_NAME=Windows;;
    MINGW*)     OS_NAME=Windows;;
    *)          OS_NAME="UNKNOWN:$(uname -s)"
esac

# Check for debug mode
[ "$DEBUG_MODE" = true ] && echo "Sourcing .zshrc"

export XDG_CONFIG_HOME="$HOME/.config"                          # Common config dir
export XDG_DATA_HOME="$HOME/.local"                             # Common data dir
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"                           # ZSH dotfile subdir

# Source all .zsh files in ZDOTDIR/conf.d (config snippets)
for config ($ZDOTDIR/conf.d/*.zsh) source $config
fpath=($ZDOTDIR/completions $fpath)
# autoload -U compinit && compinit

export DOTFILES="$HOME/dotfiles/dotfiles"                       # Dotfile dir
export VISUAL=nvim                                              # Set default visual editor
export EDITOR="${VISUAL}"                                       # Set default text editor
export LANG=en_US.UTF-8                                         # Default term language setting
export UPDATE_ZSH_DAYS=7                                        # How often to check for ZSH updates
export THEME="alien-minimal"
export SSH_THEME="$THEME"
setopt auto_cd;                                                 # Perform cd if command matches dir
setopt auto_list;                                               # List choices if unambiguous completion
setopt auto_pushd;                                              # Push old directory into stack
setopt pushd_ignore_dups;                                       # Ignore multiple copies of same dir in stack

HYPHEN_INSENSITIVE="true"                                       # Hyphen and dash will be interchangeable
COMPLETION_WAITING_DOTS="true"                                  # Display dots while loading completions
DISABLE_UNTRACKED_FILES_DIRTY="true"                            # Untracked files won't be dirty (for speed)

if [ is_ssh ]; then
    export VIM_SSH_COMPAT=1
    export THEME=$SSH_THEME
fi

# PLUGINS {{{1
# Zplug Config {{{2
# Download zplug if it doesn't exist
[ ! -d ~/.zplug ] && git clone https://github.com/zplug/zplug ~/.zplug

# Essential
source ~/.zplug/init.zsh

# Plugin Definitions {{{2

zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "mafredri/zsh-async", from:github
zplug "changyuheng/zsh-interactive-cd", from:github, use:zsh-interactive-cd.plugin.zsh
# zplug "plugins/vi-mode", from:"oh-my-zsh", as:plugin, use:vi-mode.plugin.zsh

# Themes
zplug "bhilburn/powerlevel9k", \
    use:powerlevel9k.zsh-theme, \
    as:theme, \
    if:'[ $THEME = pl9k ]'

zplug "themes/sorin", \
    from:oh-my-zsh, \
    use:sorin.zsh-theme, \
    as:theme, \
    if:'[ $THEME = sorin ]'

zplug "eendroroy/alien", \
    as:theme, \
    if:'[ $THEME = alien ]'

zplug "eendroroy/alien-minimal", \
    as:theme, \
    if:'[ $THEME = alien-minimal ]'

zplug "sindresorhus/pure", \
    use:pure.zsh, \
    from:github, \
    as:theme, \
    if:'[ "$THEME" = "pure" ]'

# Must be loaded last (or deferred)
zplug "zsh-users/zsh-syntax-highlighting", \
    defer:2

# Source bash files
# zplug "$HOME", from:local, defer:1, use:'.{bash_aliases,bash_functions}'
# zplug "$HOME", from:local, defer:2, use:'.bash_linux', if:'[[ $OSTYPE == linux* ]]'
# zplug "$HOME", from:local, defer:2, use:'.bash_mac', if:'[[ $OSTYPE == darwin* ]]'

# Zplug Load {{{2
# Install plugins if there are plugins that have not been installed
if ! zplug check; then
  printf "Install missing plugins? [y/N]: "
  if read -q; then
      echo; zplug install
  fi
fi

# Syntax highlighting config
if zplug check "zsh-users/zsh-syntax-highlighting"; then
  #ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line)
  ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')

  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[cursor]='bg=yellow'
  ZSH_HIGHLIGHT_STYLES[globbing]='none'
  ZSH_HIGHLIGHT_STYLES[path]='fg=white'
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=grey'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[function]='fg=orange'
  ZSH_HIGHLIGHT_STYLES[command]='fg=green'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
  ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
  ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=cyan,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
  ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
fi

# Load zplug
[ "$DEBUG_MODE" = true ] && zplug && zplug load --verbose || zplug load

# THEME / APPEARANCE OPTIONS {{{1
# Alien minimal {{{2
if [ "$THEME" = "alien-minimal" ]; then
    export USE_NERD_FONT="$NERD_FONT"
    export AM_INITIAL_LINE_FEED=0
    export AM_SHOW_FULL_DIR=1
    export AM_KEEP_PROMPT=1                                     # Show prev right prompt until new one is ready
    export AM_VERSIONS_PROMPT=(PYTHON)
    export PROMPT_END_TAG=' $'
    export PROMPT_END_TAG_COLOR=142
    export PROMPT_START_TAG='→ '
    export AM_ERROR_ON_START_TAG=1
    export AM_PY_SYM='Py:'
    export AM_ENABLE_VI_PROMPT=1
fi

# promptlib-zsh {{{2
export PLIB_GIT_MOD_SYM=★

# colored man {{{2
export MANROFFOPT='-c'
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)

# KEYMAP {{{1
zle -N edit-command-line

bindkey -v

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
# bindkey -M vicmd 'v' edit-command-line

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# kj :: <Esc>
bindkey 'kj' vi-cmd-mode

# function zle-line-init zle-keymap-select {
#     VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
#     # RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$EPS1"
#     zle reset-prompt
# }
#
# zle -N zle-line-init
# zle -N zle-keymap-select
export KEYTIMEOUT=1                                                    # Timeout for key sequences in vi mode (10ms)

# FUNCTIONS {{{1

# relz :: Reload zsh shell
# Params
#   -d Debug mode: print verbose debug information
relz() {
  if [ "$1" = "-d" -o "$1" = "d" ]; then
    echo "Reloading zsh in debug mode... "
    export DEBUG_MODE=true
  else
    echo "Reloading zsh... "
    export DEBUG_MODE=false
  fi
  source ~/.zshrc
  echo "Complete!"
}

# is_ssh :: Return true if in SSH session
is_ssh() {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    return 0
  else
    return 1
  fi
}

[ "$DEBUG_MODE" = true ] && echo "Exiting .zshrc"

_pyenv_virtualenv_hook() {
    local ret=$?
    if [ -n "$VIRTUAL_ENV" ]; then
        eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
    else
        eval "$(pyenv sh-activate --quiet || true)" || true
    fi
    return $ret
}

if ! [[ "$PROMPT_COMMAND" =~ _pyenv_virtualenv_hook ]]; then
    PROMPT_COMMAND="_pyenv_virtualenv_hook;$PROMPT_COMMAND"
fi

pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")";;
  *)
    command pyenv "$command" "$@";;
  esac
}
# SHELL STARTUP {{{1
# Python Virtual Env
# source "$def_venv/bin/activate"

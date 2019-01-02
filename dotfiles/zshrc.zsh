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
[[ "$DEBUG_MODE" == true ]] && echo "Sourcing .zshrc"

export XDG_CONFIG_HOME="$HOME/.config"                          # Common config dir
export XDG_DATA_HOME="$HOME/.local"                           # Common data dir
export DOTFILES="$HOME/dotfiles/dotfiles"                       # Dotfile dir
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"                           # ZSH dotfile subdir
# export VISUAL=nvim                                              # Set default visual editor
# export EDITOR="${VISUAL}"                                       # Set default text editor
export LANG=en_US.UTF-8                                         # Default term language setting
export UPDATE_ZSH_DAYS=7                                        # How often to check for ZSH updates
export THEME="pure"
export SSH_THEME="pure"
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

# WSL (Windows Subsystem for Linux) Fixes
if [[ -f /proc/version ]] && grep -q "Microsoft" /proc/version; then

  # Fix umask value if WSL didn't set it properly.
  # https://github.com/Microsoft/WSL/issues/352
  [[ "$(umask)" == "000" ]] && umask 022

  # Don't change priority of background processes with nice.
  # https://github.com/Microsoft/WSL/issues/1887
  unsetopt BG_NICE

fi

# PLUGINS {{{1
# Zplug Config {{{2
# Download zplug if it doesn't exist
[[ ! -d ~/.zplug ]] && git clone https://github.com/zplug/zplug ~/.zplug

# Essential
source ~/.zplug/init.zsh

# Source all .zsh files in ZDOTDIR/functions
for config ($ZDOTDIR/functions/*.zsh) source $config

fpath=($ZDOTDIR/completions $fpath)
# autoload -U compinit && compinit

# Plugin Definitions {{{2

zplug "zplug/zplug", hook-build:'zplug --self-manage'
# zplug "plugins/git", from:oh-my-zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "mafredri/zsh-async", from:github

# Themes
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme, as:theme, if:'[[ $THEME == pl9k ]]'
zplug "themes/sorin", from:oh-my-zsh, use:sorin.zsh-theme, as:theme, if:'[[ $THEME == sorin ]]'
zplug "eendroroy/alien", as:theme, if:'[[ $THEME == alien ]]'
zplug "eendroroy/alien-minimal", as:theme, if:'[[ $THEME == alien-minimal ]]'
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme, if:'[[ $THEME == pure ]]'

# Must be loaded last (or deferred)
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Source bash files
zplug "$HOME", from:local, defer:1, use:'.{bash_aliases,bash_functions}'
# zplug "$HOME", from:local, defer:2, use:'.bash_linux', if:'[[ $OSTYPE == linux* ]]'
zplug "$HOME", from:local, defer:2, use:'.bash_mac', if:'[[ $OSTYPE == darwin* ]]'

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
[[ "$DEBUG_MODE" == true ]] && zplug && zplug load --verbose || zplug load

# ALIASES {{{1
alias zshc='vim ~/.zshrc'
alias zrel='relz'

# Source Bash Config Files
source_sh() {
  emulate sh -c "source $@"
}

# Currently handled by zplug
source_bash=(
#  ~/.bash_aliases
#  ~/.bash_functions
#  ~/.bash_mac
#  ~/.bash_windows
$ZDOTDIR/env.zsh
~/.bash_linux
)

for file in $source_bash
  do
    [[ ! -f $file ]] && return;
    [[ "$DEBUG_MODE" == true ]] && echo "Sourcing $file"
    source_sh $file
  done

# FUNCTIONS {{{1

# relz :: Reload zsh shell
# Params
#   -d Debug mode: print verbose debug information
relz() {
  if [[ "$1" == "-d" ]]; then
    echo "Reloading zsh in debug mode... "
    export DEBUG_MODE=true
  else
    echo "Reloading zsh... "
    export DEBUG_MODE=false
  fi
  source ~/.zshrc
  echo "Complete!"
}

# whichvim :: Return Neovim if found in system; otherwise vim if found
whichvim() {
  hash nvim &> /dev/null && echo "Found Neovim" || "Did not find Neovim"
  hash vim &> /dev/null && echo "Found Vim" || "Did not find Vim"
}

# is_ssh :: Return true if in SSH session
is_ssh() {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    return 0
  else
    return 1
  fi
}

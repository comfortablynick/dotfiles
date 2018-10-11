#!/usr/bin/env zsh
# ZSH CONFIG ====================================

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

# =============================================================================
#                                   Plugins
# =============================================================================

# ZPLUG
# Download zplug if it doesn't exist
[[ ! -d ~/.zplug ]] && git clone https://github.com/zplug/zplug ~/.zplug

# Essential
source ~/.zplug/init.zsh

###############################################################################
# <-- PLUGINS START ----------------------------->

zplug "zplug/zplug", hook-build:'zplug --self-manage'

zplug "plugins/git", from:oh-my-zsh

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-autosuggestions"

# Themes
zplug "bhilburn/powerlevel9k", \
  use:powerlevel9k.zsh-theme, \
  if:"[[ $SSH_CONNECTION = '' ]]"

zplug "themes/kennethreitz", \
  from:oh-my-zsh, \
  as:theme, \ 
  if:"[[ -n $SSH_CONNECTION != '' ]]"

# Must be loaded last
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# <-- PLUGINS END ------------------------------->
###############################################################################

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
  ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'
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

# Powerlevel9k Config
if zplug check "bhilburn/powerlevel9k"; then
  # Easily switch primary foreground/background colors
  DEFAULT_FOREGROUND=006 DEFAULT_BACKGROUND=235
  DEFAULT_COLOR=$DEFAULT_FOREGROUND
  DEFAULT_USER=$USER

  if [[ -n $SSH_CONNECTION ]]; then
    POWERLEVEL9K_MODE="default"
  else
    POWERLEVEL9K_MODE="nerdfont-complete"
  fi

  POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  #POWERLEVEL9K_SHORTEN_STRATEGY="truncate_right"

  POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=false

  POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
  POWERLEVEL9K_ALWAYS_SHOW_USER=false

  POWERLEVEL9K_CONTEXT_TEMPLATE="\uF109 %m"

  POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="$DEFAULT_BACKGROUND"

  POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0B4"
  POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"
  POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0B6"
  POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"

  POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

  POWERLEVEL9K_STATUS_VERBOSE=true
  POWERLEVEL9K_STATUS_CROSS=true
  POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  #POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{cyan}\u256D\u2500%f"
  #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{014}\u2570%F{cyan}\uF460%F{073}\uF460%F{109}\uF460%f "
  #POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭─%f"
  #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰─%F{008}\uF460 %f"
  #POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
  #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{008}> %f"

  POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭"
  #POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="❱ "
  POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰\uF460 "

  #POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context ssh root_indicator dir_writable dir )
  #POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon root_indicator context dir_writable dir vcs)
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir_writable dir vcs)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time background_jobs status time virtualenv ssh)

  POWERLEVEL9K_VIRTUALENV_BACKGROUND="$(( DEFAULT_BACKGROUND + 4 ))"
  POWERLEVEL9K_VIRTUALENV_FOREGROUND="$DEFAULT_FOREGROUND"

  POWERLEVEL9K_VCS_CLEAN_BACKGROUND="green"
  POWERLEVEL9K_VCS_CLEAN_FOREGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="yellow"
  POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="magenta"
  POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="$DEFAULT_BACKGROUND"

  POWERLEVEL9K_DIR_HOME_BACKGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_DIR_HOME_FOREGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="$DEFAULT_BACKGROUND"

  POWERLEVEL9K_STATUS_OK_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
  POWERLEVEL9K_STATUS_OK_BACKGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_STATUS_OK_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"

  POWERLEVEL9K_STATUS_ERROR_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"
  POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"

  POWERLEVEL9K_HISTORY_FOREGROUND="$DEFAULT_FOREGROUND"

  POWERLEVEL9K_TIME_FORMAT="%D{%T \uF017}" #  15:29:33
  POWERLEVEL9K_TIME_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_TIME_BACKGROUND="$DEFAULT_BACKGROUND"

  POWERLEVEL9K_VCS_GIT_GITHUB_ICON=""
  POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=""
  POWERLEVEL9K_VCS_GIT_GITLAB_ICON=""
  POWERLEVEL9K_VCS_GIT_ICON=""

  POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_EXECUTION_TIME_ICON="\u23F1"

  #POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
  #POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0

  POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="$DEFAULT_FOREGROUND"

  POWERLEVEL9K_USER_ICON="\uF415" # 
  POWERLEVEL9K_USER_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_USER_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_USER_ROOT_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_USER_ROOT_BACKGROUND="$DEFAULT_BACKGROUND"

  POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="magenta"
  POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
  POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$(( $DEFAULT_BACKGROUND - 2 ))"
  POWERLEVEL9K_ROOT_ICON=$'\uF198'  # 

  POWERLEVEL9K_SSH_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_SSH_FOREGROUND="yellow"
  POWERLEVEL9K_SSH_BACKGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_SSH_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
  POWERLEVEL9K_SSH_BACKGROUND="$(( $DEFAULT_BACKGROUND - 2 ))"
  POWERLEVEL9K_SSH_ICON="\uF489"  # 

  POWERLEVEL9K_HOST_LOCAL_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_HOST_LOCAL_BACKGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_HOST_REMOTE_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_HOST_REMOTE_BACKGROUND="$DEFAULT_BACKGROUND"

  POWERLEVEL9K_HOST_ICON_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_HOST_ICON_BACKGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_HOST_ICON="\uF109" # 

  POWERLEVEL9K_OS_ICON_FOREGROUND="$DEFAULT_FOREGROUND"
  POWERLEVEL9K_OS_ICON_BACKGROUND="$DEFAULT_BACKGROUND"

  POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_LOAD_WARNING_BACKGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_LOAD_NORMAL_BACKGROUND="$DEFAULT_BACKGROUND"
  POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="red"
  POWERLEVEL9K_LOAD_WARNING_FOREGROUND="yellow"
  POWERLEVEL9K_LOAD_NORMAL_FOREGROUND="green"
  POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_COLOR="red"
  POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_COLOR="yellow"
  POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_COLOR="green"
fi


# =============================================================================
#                                   Options
# =============================================================================
# SYSTEM OPTIONS

# WSL (Windows Subsystem for Linux) Fixes
# if [[ -f /proc/version ]] && grep -q "Microsoft" /proc/version; then
  # Fix WSL umask (Handled in sourced bash file)
  # [[ "$(umask)" == "000" ]] && umask 022
  # Don't change priority of background processes with nice.
  # https://github.com/Microsoft/WSL/issues/1887
  # unsetopt BG_NICE
# fi

export LANG=en_US.UTF-8                                 # Default term language setting
export UPDATE_ZSH_DAYS=7                                # How often to check for ZSH updates
HYPHEN_INSENSITIVE="true"                               # Hyphen and dash will be interchangeable
COMPLETION_WAITING_DOTS="true"                          # Display dots while loading completions
DISABLE_UNTRACKED_FILES_DIRTY="true"                    # Untracked files won't be dirty (for speed)

[[ "$DEBUG_MODE" == true ]] && zplug load --verbose || zplug load

# =============================================================================
#                                   Aliases
# =============================================================================
alias zshc='vim ~/.zshrc'
alias zrel='relz'


# Source Aliases in Bash Files
source_sh() {
  emulate sh -c "source $@"
}

source_bash=(
  ~/.bash_aliases
  ~/.bash_linux
  ~/.bash_functions
)

for file in $source_bash
  do
    [[ "$DEBUG_MODE" == true ]] && echo "Sourcing $file"
    source_sh $file
  done

# =============================================================================
#                                 Functions
# =============================================================================

# relz :: Reload zsh shell
#
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


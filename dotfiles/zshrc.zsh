#!/usr/bin/env zsh
# vim: fdl=1:
#            _
#   ____ ___| |__  _ __ ___
#  |_  // __| '_ \| '__/ __|
#  _/ /_\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|

[[ $- != *i* ]] && return                                       # Everything after this line for interactive only

# PROFILE / DEBUG {{{1
export DEBUG_MODE=false
export PROFILE=0
export CURRENT_SHELL=zsh

# Check for debug mode {{{2
[[ $DEBUG_MODE = true ]] && echo "Sourcing .zshrc"
# START_TIME="$(date)"

if [[ $PROFILE -eq 1 ]]; then
    # from https://esham.io/2018/02/zsh-profiling
    zmodload zsh/datetime
    setopt PROMPT_SUBST
    PS4='+$EPOCHREALTIME %N:%i> '

    logfile=$(mktemp zsh_profile.XXXXXXXX)
    echo "Logging to $logfile"
    exec 3>&2 2>$logfile

    setopt XTRACE
fi

# ENVIRONMENT {{{1
# OS Type {{{2
case "$(uname -s)" in
    Linux*)     OS_NAME=Linux;;
    Darwin*)    OS_NAME=Mac;;
    CYGWIN*)    OS_NAME=Windows;;
    MINGW*)     OS_NAME=Windows;;
    *)          OS_NAME="UNKNOWN:$(uname -s)"
esac

# sh_source :: source with sh compatibilty {{{2
sh_source() {
    alias shopt=':'
    alias _expand=_bash_expand
    alias _complete=_bash_comp
    emulate -L sh
    setopt kshglob noshglob braceexpand

    builtin source "$@"
}

alias .=sh_source

# Completion {{{2
autoload -Uz compinit && compinit                               # Needed to autoload completions
autoload -Uz bashcompinit && bashcompinit                       # Bash completions must be sourced

# Directories {{{2
export XDG_CONFIG_HOME=${HOME}/.config                          # Common config dir
export XDG_DATA_HOME=${HOME}/.local/share                       # Common data dir
export ZDOTDIR=${HOME}                                          # ZSH dotfile subdir
typeset -A ZINIT
ZINIT[HOME_DIR]=${ZDOTDIR}/.zinit

for shfile ($XDG_CONFIG_HOME/shell/conf.d/*.sh) sh_source $shfile
for config ($XDG_CONFIG_HOME/zsh/conf.d/*.zsh) source $config

fpath=($XDG_CONFIG_HOME/zsh/completions
    $XDG_CONFIG_HOME/zsh/functions
    $XDG_CONFIG_HOME/shell/functions
    $fpath)

# Environment variables {{{2
export DOTFILES="$HOME/dotfiles/dotfiles"                       # Dotfile dir
export VISUAL=nvim                                              # Set default visual editor
export EDITOR="${VISUAL}"                                       # Set default text editor
export LANG=en_US.UTF-8                                         # Default term language setting
export UPDATE_ZSH_DAYS=7                                        # How often to check for ZSH updates
export ZSH_THEME="powerlevel10k"                                # Prompt theme

if [[ $MOSH_CONNECTION -eq 0 ]] && hash delta; then
    export GIT_PAGER="delta --dark"
fi

# Autoload functions {{{2
autoload -Uz remove_last_history_entry
autoload -Uz fh
autoload -Uz cdp
autoload -Uz mc

# SHELL OPTS {{{1
# General {{{2
typeset -U path                                                 # Unique PATH entries only
setopt auto_cd;                                                 # Perform cd if command matches dir
setopt auto_list;                                               # List choices if unambiguous completion
setopt auto_pushd;                                              # Push old directory into stack
setopt pushdsilent;                                             # Don't echo directories during pushd
setopt pushd_ignore_dups;                                       # Ignore multiple copies of same dir in stack
setopt interactivecomments;                                     # Allow bash-style command line comments
HYPHEN_INSENSITIVE="true"                                       # Hyphen and dash will be interchangeable
COMPLETION_WAITING_DOTS="true"                                  # Display dots while loading completions
DISABLE_UNTRACKED_FILES_DIRTY="true"                            # Untracked files won't be dirty (for speed)
DIRSTACKSIZE=20                                                 # Limit size of stack since we're always using it

# History {{{2
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt NO_SHARE_HISTORY
unsetopt SHARE_HISTORY                                          # Shells share history
setopt BANG_HIST                                                # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY                                         # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY                                       # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST                                   # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS                                         # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS                                     # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS                                        # Do not display a line previously found.
setopt HIST_IGNORE_SPACE                                        # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS                                        # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS                                       # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY                                              # Don't execute immediately upon history expansion.
setopt HIST_BEEP                                                # Beep when accessing nonexistent history.

# Keymaps {{{2
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey -M viins "kj" vi-cmd-mode                               # Add `kj` -> ESC

autoload -Uz edit-command-line                                  # ! in vi cmd mode opens prompt in $EDITOR
zle -N edit-command-line
bindkey -M vicmd '!' edit-command-line

autoload -Uz fzy-edit
zle -N fzy-edit
bindkey '^E' fzy-edit

# PLUGINS {{{1
# zinit Config {{{2
if ! [[ -d $ZINIT[HOME_DIR] ]]; then
    mkdir $ZINIT[HOME_DIR]
    chmod g-rwX $ZINIT[HOME_DIR]
fi

if ! [[ -d $ZINIT[HOME_DIR]/bin/.git ]]; then
    echo ">>> Downloading zinit to $ZINIT[HOME_DIR]/bin"
    git clone --depth 10 https://github.com/zdharma/zinit.git $ZINIT[HOME_DIR]/bin
    echo ">>> Done"
fi

source $ZINIT[HOME_DIR]/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zinit Plugin Definitions {{{2
zinit ice if'[[ $ZSH_THEME = powerlevel10k ]]'
zinit load romkatv/powerlevel10k

zinit ice pick"async.zsh" src"pure.zsh" if'[[ $ZSH_THEME = pure ]]'
zinit light sindresorhus/pure

zinit ice wait"0" blockf lucid
zinit light zsh-users/zsh-completions

zinit ice wait"0" atload"_zsh_autosuggest_start" lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"0" atinit"zpcompinit; zpcdreplay" lucid
zinit light zdharma/fast-syntax-highlighting

zinit ice wait"1" multisrc'shell/{completion,key-bindings}.zsh' lucid
zinit load junegunn/fzf

zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

# THEME / APPEARANCE OPTIONS {{{1
# Alien minimal {{{2
if [[ $ZSH_THEME = "alien-minimal" ]]; then
    export USE_NERD_FONT="$NERD_FONT"
    export AM_INITIAL_LINE_FEED=0
    export AM_SHOW_FULL_DIR=1
    export AM_KEEP_PROMPT=1
    export AM_SEGMENT_UPDATE=1
    export AM_VERSIONS_PROMPT=(PYTHON)
    export PROMPT_END_TAG=' $'
    export PROMPT_END_TAG_COLOR=142
    export PROMPT_START_TAG='→ '
    export AM_ERROR_ON_START_TAG=1
    export AM_PY_SYM='Py:'
    export AM_ENABLE_VI_PROMPT=1
fi

# Alien {{{2
# if [ "$ZSH_THEME" = "alien" ]; then
#     export ALIEN_SECTIONS_LEFT=(
#       exit
#       battery
#       user
#       path
#       vcs_branch
#       vcs_status
#       vcs_dirty
#       ssh
#       venv
#       prompt
#   )
# fi

# starship {{{2
if [[ $ZSH_THEME = "starship" ]]; then
    eval "$(starship init zsh)"
fi

# promptlib-zsh {{{2
export PLIB_GIT_MOD_SYM='★'

# Colored man {{{2
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


# FUNCTIONS {{{1
# cd :: cd with fuzzy find {{{2
function cd() {
    if [[ $# -ne 0 ]]; then
        builtin cd "$@"
        return
    fi
    local fuzzy_finder="fzy"
    #     local lsd=$(eval "command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    # -o -type d -print 2> /dev/null | sort | cut -b3-")
    local dir=$(eval "$FZF_CD_WITH_HIDDEN_COMMAND" | $fuzzy_finder)
    # local dir="$(printf '%s\n' "${lsd[@]}" | $fuzzy_finder)"
    [[ ${#dir} -ne 0 ]] || return 0
    builtin cd "$dir"
}

# chpwd :: execute on directory change {{{2
chpwd() {
    # List directory contents
    # Ignore if LS_AFTER_CD is not set, or we are in HOME
    { [[ $LS_AFTER_CD -ne 1 ]] || [[ $PWD = $HOME ]] } && return
    ls --group-directories-first 2>/dev/null
    # exa --group-directories-first
}

# SHELL STARTUP {{{1
# Debug end {{{2
[[ $DEBUG_MODE = true ]] && echo "Exiting .zshrc"

# Profiling end {{{2
if [[ $PROFILE -eq 1 ]]; then
    unsetopt XTRACE
    exec 2>&3 3>&-
fi

# vim:ft=zsh fdl=1:
#            _
#   ____ ___| |__  _ __ ___
#  |_  // __| '_ \| '__/ __|
#  _/ /_\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|
#
# Profile/debug {{{1
# Exit if not interactive {{{2
[[ $- != *i* ]] && return                                       # Everything after this line for interactive only

# variables {{{2
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

# Environment {{{1
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

_fzf_compgen_path() {
    echo "$1"
    fd -HL -t f --color=always "$1" 2>/dev/null # | sed 's@^\./@@'
}

_fzf_compgen_dir() {
    fd -HL -t d --color=always "$1" 2>/dev/null
}

# Completion {{{2
autoload -Uz compinit && compinit                               # Needed to autoload completions
autoload -Uz bashcompinit && bashcompinit                       # Bash completions must be sourced

# Environment variables {{{2
export LANG=en_US.UTF-8
export UPDATE_ZSH_DAYS=7
export ZSH_THEME="powerlevel10k"

# if [[ $MOSH_CONNECTION -eq 0 ]] && (( $+commands[delta] )); then
#     export GIT_PAGER="delta --dark"
# fi
export ZDOTDIR=${HOME}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:=${HOME}/.local/share}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=${HOME}/.cache}
export ZSH_CACHE_DIR=${XDG_CACHE_HOME}/zsh

[[ ! -d ${ZSH_CACHE_DIR} ]] && command mkdir -p ${ZSH_CACHE_DIR}


# Config snippets {{{2
# for shfile (${XDG_CONFIG_HOME}/shell/conf.d/*.sh) sh_source $shfile
for config (${XDG_CONFIG_HOME}/zsh/conf.d/*.zsh) source $config

fpath=(${XDG_CONFIG_HOME}/zsh/completions
    ${XDG_CONFIG_HOME}/zsh/functions
    ${XDG_CONFIG_HOME}/shell/functions
    $fpath)

# Autoload functions {{{2
autoload -Uz remove_last_history_entry
autoload -Uz direnv
autoload -Uz fh
autoload -Uz cf
autoload -Uz mc
autoload -Uz cd
autoload -Uz lo

# chpwd functions {{{3
autoload -Uz list_all
chpwd_functions+=("list_all")

# Shell opts {{{1
# General {{{2
typeset -U path
setopt auto_cd    auto_list           pushd_ignore_dups
setopt auto_pushd interactivecomments pushdsilent
HYPHEN_INSENSITIVE="true"            # Hyphen and dash will be interchangeable
COMPLETION_WAITING_DOTS="true"       # Display dots while loading completions
DISABLE_UNTRACKED_FILES_DIRTY="true" # Untracked files won't be dirty (for speed)
DIRSTACKSIZE=20                      # Limit size of stack since we're always using it

# History {{{2
HISTFILE=${ZSH_CACHE_DIR}/histfile
HISTSIZE=10000000
SAVEHIST=10000000
unsetopt share_history
setopt   no_share_history
setopt   bang_hist          extended_history  inc_append_history
setopt   hist_save_no_dups  hist_ignore_dups  hist_expire_dups_first
setopt   hist_find_no_dups  hist_ignore_space hist_ignore_all_dups
setopt   hist_reduce_blanks hist_verify       hist_beep

# Keymaps {{{2
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey -M viins "kj" vi-cmd-mode

autoload -Uz edit-command-line # ! in vi cmd mode opens prompt in $EDITOR
zle -N edit-command-line
bindkey -M vicmd '!' edit-command-line

autoload -Uz fzy-edit
zle -N fzy-edit
bindkey '^E' fzy-edit

# Plugins {{{1
# zinit {{{2
export ZINIT_HOME=${HOME}/.zinit
typeset -A ZINIT=(
   HOME_DIR          ${ZINIT_HOME}
   BIN_DIR           ${ZINIT_HOME}/bin
   PLUGINS_DIR       ${ZINIT_HOME}/plugins
   COMPLETIONS_DIR   ${ZINIT_HOME}/completions
   SNIPPETS_DIR      ${ZINIT_HOME}/snippets
   COMPINIT_OPTS     -C
   ZCOMPDUMP_PATH    ${ZSH_CACHE_DIR}/zcompdump-${ZSH_VERSION}
)

ZINIT_SCRIPT=${ZINIT[BIN_DIR]}/zinit.zsh

### Added by Zinit's installer
if [[ ! -f ${ZINIT_SCRIPT} ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "${ZINIT[HOME_DIR]}" && command chmod g-rwX "${ZINIT[HOME_DIR]}" && \
        command git clone https://github.com/zdharma/zinit "${ZINIT[BIN_DIR]}" && \
            print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
            print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source ${ZINIT_SCRIPT}
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

zinit light zsh-users/zsh-autosuggestions
zinit snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh
zinit snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh

zinit ice if'[[ $ZSH_THEME = powerlevel10k ]]'
zinit light romkatv/powerlevel10k

# zinit ice atpull'zinit creinstall -q "$PWD"'
# zinit light zsh-users/zsh-completions

# zinit ice wait"1" atload'zstyle ":fzf-tab:*" fzf-command fzf-tmux' lucid
# zinit light Aloxaf/fzf-tab

# # Use my fork of trapd00r plugin
# zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
#     atpull'%atclone' pick"clrs.zsh" nocompile'!' \
#     atload'zstyle ":completion:*:default" list-colors "${(s.:.)LS_COLORS}"'
#     zinit light comfortablynick/LS_COLORS

# Theme / appearance options {{{1
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

# Shell startup {{{1
# Debug end {{{2
[[ $DEBUG_MODE = true ]] && echo "Exiting .zshrc"

# Profiling end {{{2
if [[ $PROFILE -eq 1 ]]; then
    unsetopt XTRACE
    exec 2>&3 3>&-
fi

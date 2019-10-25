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

# Completion {{{2
autoload -Uz compinit && compinit                               # Needed to autoload completions
autoload -Uz bashcompinit && bashcompinit                       # Bash completions must be sourced

# Directories {{{2
export XDG_CONFIG_HOME=${HOME}/.config                          # Common config dir
export XDG_DATA_HOME=${HOME}/.local/share                       # Common data dir
export ZDOTDIR=${HOME}                                          # ZSH dotfile subdir
export ZPLG_HOME=${ZDOTDIR}/.zplugin                            # Zplugin install dir

for config ($XDG_CONFIG_HOME/zsh/conf.d/*.zsh) source $config
fpath=($XDG_CONFIG_HOME/zsh/completions $fpath)

export DOTFILES="$HOME/dotfiles/dotfiles"                       # Dotfile dir
export VISUAL=nvim                                              # Set default visual editor
export EDITOR="${VISUAL}"                                       # Set default text editor
export LANG=en_US.UTF-8                                         # Default term language setting
export UPDATE_ZSH_DAYS=7                                        # How often to check for ZSH updates

# Set theme {{{2
export ZSH_THEME="powerlevel10k"
export SSH_THEME="$ZSH_THEME"

if [ is_ssh ]; then
    export VIM_SSH_COMPAT=1
    export ZSH_THEME=$SSH_THEME
fi

# SHELL OPTS {{{1
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

# SHELL HISTORY {{{1
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
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
setopt SHARE_HISTORY                                            # Shells share history

# PLUGINS {{{1
# Zplugin Config {{{2
if ! [[ -d $ZPLG_HOME ]]; then
    mkdir $ZPLG_HOME
    chmod g-rwX $ZPLG_HOME
fi

if ! [[ -d $ZPLG_HOME/bin/.git ]]; then
    echo ">>> Downloading zplugin to $ZPLG_HOME/bin"
    cd $ZPLG_HOME
    git clone --depth 10 https://github.com/zdharma/zplugin.git bin
    echo ">>> Done"
fi

source $ZPLG_HOME/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

# Zplugin Plugin Definitions {{{2
zplugin ice if'[[ $ZSH_THEME = powerlevel10k ]]'
zplugin load romkatv/powerlevel10k

zplugin ice pick"async.zsh" src"pure.zsh" if'[[ $ZSH_THEME = pure ]]'
zplugin light sindresorhus/pure

zplugin ice wait"0" blockf lucid
zplugin light zsh-users/zsh-completions

zplugin ice wait"0" atload"_zsh_autosuggest_start" lucid
zplugin light zsh-users/zsh-autosuggestions

zplugin ice wait"0" atinit"zpcompinit; zpcdreplay" lucid
zplugin light zdharma/fast-syntax-highlighting

zplugin ice wait"1" multisrc'shell/{completion,key-bindings}.zsh' lucid
zplugin load junegunn/fzf

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


# KEYMAP {{{1
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# kj :: <Esc>
bindkey -M viins "kj" vi-cmd-mode                               # Add `kj` -> ESC
# zle -N zle-keymap-select

# FUNCTIONS {{{1
# is_ssh :: Return true if in SSH session {{{2
is_ssh() {
  if [[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]]; then
    return 0
  else
    return 1
  fi
}

# mc :: make directory and cd into it {{{2
mc() {
    if [[ $# -ge 1 ]]; then
        mkdir -p "$1" && cd "$1" || return 1
    else
        echo "ERROR usage: $0 [DIR]"
    fi
}
# npm :: wrapper for asdf npm {{{2
npm() {
    export ASDF_SKIP_RESHIM=1
    $HOME/.asdf/shims/npm "$@"
    asdf reshim nodejs
}

# cd :: cd with fuzzy find {{{2
function cd() {
    if [[ $# -ne 0 ]]; then
        builtin cd "$@"
        return
    fi
    local fuzzy_finder="fzy"
    local lsd=$(eval "command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
-o -type d -print 2> /dev/null | sort | cut -b3-")
    local dir="$(printf '%s\n' "${lsd[@]}" | $fuzzy_finder)"
    [[ ${#dir} -ne 0 ]] || return 0
    builtin cd "$dir"
}

# cdp :: cd with fzf preview {{{2
function cdp() {
    if [[ $# -ne 0 ]]; then
        builtin cd "$@";
        return
    fi
    local lsd
    local dir
    lsd=$(eval "command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
-o -type d -print 2> /dev/null | sort | cut -b3-")
    dir="$(printf '%s\n' "${lsd[@]}" |
        fzf-tmux --reverse --preview '
            __cd_nxt="$(echo {})";
            __cd_path="$(echo $(pwd)/${__cd_nxt})";
            echo $__cd_path;
            echo;
            ls -lA --group-directories-first --color=always "${__cd_path}";
    ')"
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

# direnv :: change environment based on .envrc file
if [[ -x /usr/bin/direnv ]]; then
    _direnv_hook() {
      eval "$("/usr/bin/direnv" export zsh)";
    }
    typeset -ag precmd_functions;
    if [[ -z ${precmd_functions[(r)_direnv_hook]} ]]; then
      precmd_functions+=_direnv_hook;
    fi
fi

# asdf :: version manager {{{2
# BEGIN ANSIBLE MANAGED BLOCK: asdf
if [[ -e $HOME/.asdf/asdf.sh ]]; then
  source $HOME/.asdf/asdf.sh
  source $HOME/.asdf/completions/asdf.bash
fi
# END ANSIBLE MANAGED BLOCK: asdf

# remove_last_history_entry :: delete last `n` commands from history {{{2
remove_last_history_entry() {
    # This sub-function checks if the argument passed is a number.
    # Thanks to @yabt on stackoverflow for this :).
    is_int() ( return $(test "$@" -eq "$@" > /dev/null 2>&1); )

    # Set history file's location
    history_file="${HOME}/.zsh_history"
    history_temp_file="${history_file}.tmp"
    line_cout=$(wc -l $history_file)

    # Check if the user passed a number,
    # so we can delete x lines from history.
    lines_to_remove=1
    if [ $# -eq 0 ]; then
        # No arguments supplied, so set to one.
        lines_to_remove=1
    else
        # An argument passed. Check if it's a number.
        if $(is_int "${1}"); then
            lines_to_remove="$1"
        else
            echo "Unknown argument passed. Exiting..."
            return
        fi
    fi

    # Make the number negative, since head -n needs to be negative.
    lines_to_remove="-${lines_to_remove}"

    fc -W # write current shell's history to the history file.

    # Get the files contents minus the last entry(head -n -1 does that)
    cat $history_file | head -n "${lines_to_remove}" &> $history_temp_file
    mv "$history_temp_file" "$history_file" > /dev/null 2>&1

    fc -R # read history file.
}

# SHELL STARTUP {{{1
# Debug end {{{2
[[ $DEBUG_MODE = true ]] && echo "Exiting .zshrc"

# Profiling end {{{2
if [[ $PROFILE -eq 1 ]]; then
    unsetopt XTRACE
    exec 2>&3 3>&-
fi

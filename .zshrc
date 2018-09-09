########################################################################
# interactive shell configuration
########################################################################

setopt ALIASES
setopt AUTOCD
setopt AUTO_PUSHD
setopt BEEP
setopt CORRECT
setopt CORRECT_ALL
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt NOMATCH
setopt NOTIFY
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_TO_HOME
setopt RM_STAR_SILENT
# see also history section below

# # Show contents of directory after cd-ing into it
# chpwd() {
#   ls -lrthG
# }

fpath=(/usr/local/share/zsh-completions $fpath)

autoload -Uz compinit
autoload -Uz bashcompinit

# +X means don't execute, only load
autoload -Uz +X zmv

# quote pasted URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# bracketed paste mode (in case nothing else enables, like a plugin)
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# edit command line in $EDITOR with m-e (or esc+e)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M emacs '^[e' edit-command-line

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

if [[ -s "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

zstyle ':completion:*:descriptions' format %B%d%b # bold

# color scheme
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-ocean.sh"
[[ -s "$BASE16_SHELL" ]] && source "$BASE16_SHELL"

# iTerm2 integration and utilities (e.g., imgcat)
[[ -e "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"


########################################################################
# oh-my-zsh
########################################################################

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    # Path to your oh-my-zsh configuration.
    export ZSH="$HOME/.oh-my-zsh"
    export DISABLE_AUTO_UPDATE="true"
    export COMPLETION_WAITING_DOTS="true"
    unset ZSH_THEME

    plugins=(                    \
        rbenv                    \
        extract                  \
        gpg-agent                \
        history-substring-search \
        safe-paste               \
        ssh-agent                \
        yum                      \
        zsh-syntax-highlighting  \
    )

    source "$ZSH/oh-my-zsh.sh"

    # prompt
    [[ -s "$HOME/.prompt" ]] && source "$HOME/.prompt"
fi


########################################################################
# keyboard
########################################################################

# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind UP and DOWN arrow keys (compatibility fallback
# for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


########################################################################
# vi-mode (based on oh-my-zsh plugin)
########################################################################

# function zle-keymap-select zle-line-init
# {
#     # change cursor shape in iTerm2
#     case $KEYMAP in
#         vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
#         viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
#     esac

#     zle reset-prompt
#     zle -R
# }

# function zle-line-finish
# {
#     print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
# }

# zle -N zle-line-init
# zle -N zle-line-finish
# zle -N zle-keymap-select

# bindkey -v

# # 10ms for key sequences
# KEYTIMEOUT=1

# # bindings

# # move through history
# bindkey -a 'gg' beginning-of-buffer-or-history
# bindkey -a 'g~' vi-oper-swap-case
# bindkey -a G end-of-buffer-or-history

# # search history ('f'ind)
# bindkey "^F" history-incremental-search-backward

# # undo/redo
# bindkey -a u undo
# bindkey -a '^R' redo
# bindkey '^?' backward-delete-char
# bindkey '^H' backward-delete-char

# # get cursor position (like vi)
# bindkey '^G' what-cursor-position


########################################################################
# home git setup
#########################################################################

alias home="git --work-tree=$HOME --git-dir=$HOME/.home.git"

# function setup_for_home_git
# {
#     if [[ $HOME == $PWD ]]
#     then
#         export GIT_DIR=$HOME/.home.git
#         export GIT_WORK_TREE=$HOME
#     else
#         unset GIT_DIR
#         unset GIT_WORK_TREE
#     fi
# }

# setup_for_home_git
# chpwd_functions=( $chpwd_functions setup_for_home_git )


########################################################################
# history
########################################################################

setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

export HISTFILE="$HOME/.history"
export HISTFILESIZE=50000000
export HISTSIZE=5000000
export SAVEHIST=$HISTSIZE


########################################################################
# sources
########################################################################

# aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# misc (if they exist)
# (using `hash` instead of `test -e` for location-agnostic presence testing)
hash "git-helpers.sh" >/dev/null 2>&1 && source "git-helpers.sh"
hash "work.sh"        >/dev/null 2>&1 && source "work.sh"
hash "local.sh"       >/dev/null 2>&1 && source "local.sh"


########################################################################
# SSH
########################################################################

# fix up permissions every time, just in case
umask 002
if [[ -d "$HOME/.ssh" ]]; then
    chmod 700 "$HOME/.ssh" 2> /dev/null
    chmod 600 "$HOME/.ssh/*" 2> /dev/null
fi

# vim: set ft=zsh tw=100 :

#!/usr/bin/env bash

# Safer defaults
set -o noclobber
set -o pipefail

# Grep/RG defaults
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# ls family
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'

# Misc
alias ..='cd ..'
alias ...='cd ../..'
alias please='sudo'

# Prompt: compact with git branch if available
__git_branch_ps1() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/.*/ &/' || true
}
PS1='\[\e[0;32m\]\u@\h \[\e[0;34m\]\w\[\e[0;33m\]$(__git_branch_ps1)\[\e[0m\]\n$ '


# ╭──────────────────────────────────────────────────────────╮
# │  Optimized Zsh Configuration with Zinit Turbo Mode       │
# │  Based on best practices from Zinit documentation        │
# ╰──────────────────────────────────────────────────────────╯

# Performance optimization settings - MUST be at top
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt AUTO_CD AUTO_PUSHD PUSHD_SILENT NO_BEEP
KEYTIMEOUT=1
setopt AUTO_CD AUTO_PUSHD PUSHD_SILENT NO_BEEP
KEYTIMEOUT=1
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Set Kitty installation directory
export KITTY_INSTALLATION_DIR="/home/miko/.local/kitty.app/lib/kitty"

# (Kitty shell integration handled later with guards)

# Zinit optimization variables
typeset -A ZINIT
ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1  # Skip disk checks for 10ms gain
ZINIT[COMPINIT_OPTS]=-C              # Speed up compinit

# Initialize Zinit (guarded)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ -r "${ZINIT_HOME}/zinit.zsh" ]]; then
  source "${ZINIT_HOME}/zinit.zsh"
else
  print -r -- "[zsh] zinit not found at ${ZINIT_HOME}; skipping plugin load" >&2
fi

# Ensure compinit is available early for completion helpers
if ! typeset -f compdef >/dev/null 2>&1; then
  autoload -Uz compinit && compinit -C
fi

# Kitty Shell Integration (completions + OSC 133 support)
if [[ -r ~/.zsh_kitty_integration ]]; then
  source ~/.zsh_kitty_integration  # user completions for kitty/kitten
fi
if [[ -r "$KITTY_INSTALLATION_DIR/shell-integration/zsh/kitty-integration" ]]; then
  export KITTY_SHELL_INTEGRATION="enabled"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

# Immediate prompt (no delay) - Starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Fast directory jumper - Load immediately for cd functionality
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Essential plugins with turbo mode - Load after prompt
# wait'' means wait for prompt, lucid means quiet loading
if (( $+functions[zinit] )); then
  # Autosuggestions - Load silently after 0.1s
  zinit ice wait'0a' lucid frozen atload'_zsh_autosuggest_start'
  zinit light zsh-users/zsh-autosuggestions

  # Fast syntax highlighting
  zinit ice wait'0b' lucid frozen atload'FAST_HIGHLIGHT[chroma-man]=""'
  zinit light zdharma-continuum/fast-syntax-highlighting

  # Completions - Load with blockf to prevent immediate compdef
  zinit ice wait'0c' lucid frozen blockf atpull'zinit creinstall -q .'
  zinit light zsh-users/zsh-completions

  # FZF tab completion - After completions
  zinit ice wait'0c' lucid frozen has'fzf'
  zinit light Aloxaf/fzf-tab

  # History search - Load before highlighters
  zinit ice wait'0a' lucid frozen
  zinit light zsh-users/zsh-history-substring-search

  # You-should-use suggestions
  zinit ice wait'1' lucid frozen
  zinit light MichaelAquilina/zsh-you-should-use

  # Vi mode for powerful editing
  zinit ice wait'1' lucid frozen
  zinit light jeffreytse/zsh-vi-mode

  # Auto-pair brackets/quotes in command line
  zinit ice wait'2' lucid frozen
  zinit light hlissner/zsh-autopair

  # Oh-My-Zsh snippets - Load most important ones quickly
  zinit ice wait lucid
  zinit snippet OMZP::git

  # Load less critical OMZ plugins with more delay
  zinit ice wait'2' lucid
  zinit snippet OMZP::docker-compose

  zinit ice wait'2' lucid
  zinit snippet OMZP::command-not-found

  zinit ice wait'2' lucid
  zinit snippet OMZP::extract

  # Initialize completions with turbo mode
  zinit ice wait'0' lucid atload"zicompinit; zicdreplay -q"
  zinit snippet /dev/null
fi

# FZF configuration - Optimized for performance
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# FZF sources: prefer fd, else ripgrep, else find
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v rg >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g !.git'
  export FZF_ALT_C_COMMAND='rg --files --hidden --follow -g !.git -g /*/'
else
  export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/.git/*"'
  export FZF_ALT_C_COMMAND='find . -type d -not -path "*/.git/*"'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
  --height 40% 
  --layout=reverse 
  --border=rounded
  --inline-info
  --preview-window="right:50%:wrap:hidden"
  --bind="ctrl-/:toggle-preview"
'
if command -v xclip >/dev/null 2>&1; then
  FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"$'\n--bind="ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort"'
fi

# PATH configuration - Optimized order
# Disabled local Kitty due to EGL/Wayland crash - using system package
# export PATH="/home/miko/.local/kitty.app/bin:$PATH"
export PATH="/home/miko/.cargo/bin:$PATH"
export PATH="/home/miko/.local/bin:$PATH"
export PATH="/home/miko/go/bin:$PATH"
export PATH="/home/miko/.npm-global/bin:$PATH"
export PATH="/home/miko/.fzf/bin:$PATH"
typeset -U path PATH fpath

# Environment variables
if command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
  export VISUAL='nvim'
elif command -v vim >/dev/null 2>&1; then
  export EDITOR='vim'
  export VISUAL='vim'
elif command -v nano >/dev/null 2>&1; then
  export EDITOR='nano'
  export VISUAL='nano'
else
  export EDITOR='vi'
  export VISUAL='vi'
fi
if [[ "$TERM" != "xterm-kitty" ]]; then export TERM='xterm-256color'; fi
export COLORTERM='truecolor'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export PAGER='less'
export LESS='-R --use-color -Dd+r$Du+b'
autoload -Uz colors && colors
set -o pipefail
if command -v dircolors >/dev/null 2>&1; then eval "$(dircolors -b)"; fi
if command -v gpg >/dev/null 2>&1; then export GPG_TTY="$(tty)"; fi
if command -v bat >/dev/null 2>&1; then export MANPAGER="sh -c 'col -bx | bat -l man -p'"; fi

# Tool hooks (guarded)
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
if command -v gh >/dev/null 2>&1; then
  eval "$(gh completion -s zsh)"
fi
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi
if command -v helm >/dev/null 2>&1; then
  source <(helm completion zsh)
fi

# Lazy load nvm if exists (huge performance gain)
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

# Modern CLI aliases - guarded by tool availability
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --icons --group-directories-first --header --git'
  alias la='eza -a --icons --group-directories-first'
  alias lt='eza --tree --icons --level=2'
  alias tree='eza --tree --icons'
else
  # Minimal fallbacks for common patterns
  alias ll='ls -la'
  alias la='ls -a'
fi
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
  export BAT_PAGER='less -R'
fi
if command -v fd >/dev/null 2>&1; then alias find='fd'; fi
if command -v rg >/dev/null 2>&1; then alias grep='rg'; fi
if command -v procs >/dev/null 2>&1; then alias ps='procs'; fi
if command -v btm >/dev/null 2>&1; then alias top='btm'; fi
if command -v btm >/dev/null 2>&1; then alias htop='btm'; fi
if command -v dust >/dev/null 2>&1; then alias du='dust'; fi
if command -v sd >/dev/null 2>&1; then alias sed='sd'; fi
if command -v delta >/dev/null 2>&1; then alias diff='delta'; fi
if command -v nvim >/dev/null 2>&1; then alias vim='nvim'; fi
if command -v nvim >/dev/null 2>&1; then alias vi='nvim'; fi
if command -v thefuck >/dev/null 2>&1; then eval "$(thefuck --alias)"; fi

# Git aliases - Essential ones
alias g='git'
alias ga='git add'
alias gc='git commit -v'
alias gd='git diff'
alias gs='git status'
alias gp='git push'
alias gl='git pull'

# Prefer system kitty over local app if both exist
if [[ -x /usr/bin/kitty && -x $HOME/.local/kitty.app/bin/kitty ]]; then
  alias kitty='/usr/bin/kitty'
fi

# Kitty integration (only if kitty exists)
if command -v kitty >/dev/null 2>&1; then
  alias kssh='kitty +kitten ssh'
  alias icat='kitty +kitten icat'
  alias kdiff='kitty +kitten diff'
  alias ktheme='kitty +kitten themes'
  alias kedit='kitty +kitten edit'  # Edit files in kitty
  alias kclip='kitty +kitten clipboard'  # Clipboard management
  alias knav='kitty +kitten file_browser'  # File browser
fi

# Kitty theme management functions
kitty-theme-list() {
    kitty +kitten themes --list
}

kitty-theme-set() {
    if [[ -z "$1" ]]; then
        echo "Usage: kitty-theme-set <theme-name>"
        echo "Use 'kitty-theme-list' to see available themes"
        return 1
    fi
    kitty +kitten themes --reload-in=all "$1"
}

# System navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Quick functions
mkcd() { mkdir -p "$1" && cd "$1"; }
backup() { cp -r "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"; }
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz) tar xzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xf $1 ;;
            *.zip) unzip $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "'$1' cannot be extracted" ;;
        esac
    fi
}

# Welcome banner (once per session) — Nichijou vibes :3
nichijou_banner() {
  local quotes=(
    ":3 THINGS WE THINK ARE COOL"
    "UwU Keep it cute, keep it fast"
    "x3 Be gentle with your shell"
    "(=^・ω・^=) Have a comfy session"
  )
  local q=${quotes[$RANDOM%${#quotes[@]}]}
  print -P "%F{33}── %f%F{39}$q%f %F{33}──%f"
}
if [[ -o interactive && -z ${NICH_BANNER_SHOWN:-} ]]; then
  nichijou_banner
  export NICH_BANNER_SHOWN=1
fi

# Kitty session launcher
kitty-session() {
  local s="$HOME/.config/kitty/sessions/${1:-nichijou}.session"
  if [[ -r "$s" ]]; then
    kitty --single-instance --session "$s" &>/dev/null & disown
  else
    echo "Session not found: $s" >&2
    return 1
  fi
}

# Nichijou helpers: switch motto rotation and starship palette
nich-mode() {
  case "${1:-show}" in
    sequential|directory|branch|random)
      export NICHIJOU_MOTTO_MODE="$1"
      echo "nichijou mode: $NICHIJOU_MOTTO_MODE"
      ;;
    show|status)
      echo "nichijou mode: ${NICHIJOU_MOTTO_MODE:-sequential}"
      ;;
    *)
      echo "Usage: nich-mode [sequential|directory|branch|random|show]" >&2
      return 1
      ;;
  esac
}

nich-palette() {
  local target="${1:-nichijou}"
  local cfg="$HOME/.config/starship.toml"
  if ! command -v sed >/dev/null 2>&1; then
    echo "sed is required" >&2; return 1
  fi
  # Validate palette name exists in config
  if ! rg -q "^\\s*\\[palettes\\.${target}\\]" "$cfg" 2>/dev/null; then
    echo "Palette not found: $target" >&2; return 1
  fi
  sed -i -E 's/^\s*palette = ".*"/palette = "'"$target"'"/' "$cfg"
  echo "Starship palette -> $target (will update on next prompt)"
}

# Auto-activate Python virtualenvs found in the current/project directory
_AUTO_VENV_ACTIVATED=""
auto_venv() {
  local dir venv
  dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.venv/bin/activate" ]]; then
      venv="$dir/.venv"
      break
    fi
    dir="${dir:h}"
  done
  if [[ -n "$venv" ]]; then
    if [[ "$VIRTUAL_ENV" != "$venv" ]]; then
      [[ -n "$VIRTUAL_ENV" && -n "$_AUTO_VENV_ACTIVATED" ]] && deactivate >/dev/null 2>&1 || true
      source "$venv/bin/activate" 2>/dev/null && _AUTO_VENV_ACTIVATED="$venv"
    fi
  else
    if [[ -n "$VIRTUAL_ENV" && -n "$_AUTO_VENV_ACTIVATED" ]]; then
      deactivate >/dev/null 2>&1 || true
      _AUTO_VENV_ACTIVATED=""
    fi
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_venv
add-zsh-hook precmd auto_venv

# Export face for Starship right prompt (env_var module)
nich_export_face() {
  export NICH_FACE="$($HOME/.local/bin/nichijou_motto face 2>/dev/null || echo '')"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd nich_export_face

# FZF functions - Load on demand
fh() {
    command -v fzf >/dev/null 2>&1 || { echo "fzf not found" >&2; return 1; }
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# Kitty window management functions
kitty-new-tab() {
    command -v kitty >/dev/null 2>&1 || { echo "kitty not found" >&2; return 1; }
    kitty @ new-tab --cwd=current
}

kitty-new-window() {
    command -v kitty >/dev/null 2>&1 || { echo "kitty not found" >&2; return 1; }
    kitty @ new-window --cwd=current
}

kitty-send-text() {
    command -v kitty >/dev/null 2>&1 || { echo "kitty not found" >&2; return 1; }
    if [[ -z "$1" ]]; then
        echo "Usage: kitty-send-text <text>"
        return 1
    fi
    kitty @ send-text --match recent:0 "$1"
}

# Load local overrides if exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Ensure completion cache dir exists
[[ -d ~/.zsh/cache ]] || mkdir -p ~/.zsh/cache
# Completion settings - Optimized
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache
if command -v eza >/dev/null 2>&1; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -la $realpath'
fi

# Auto suggestions config
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true

# Key bindings - Essential ones only
# Bind keys only if widgets exist (prevents warnings)
if (( $+widgets[history-substring-search-up] )); then
  bindkey '^[[A' history-substring-search-up
fi
if (( $+widgets[history-substring-search-down] )); then
  bindkey '^[[B' history-substring-search-down
fi
if (( $+widgets[fzf-history-widget] )); then bindkey '^R' fzf-history-widget; fi
if (( $+widgets[fzf-file-widget] )); then bindkey '^T' fzf-file-widget; fi
if (( $+widgets[fzf-cd-widget] )); then bindkey '^[c' fzf-cd-widget; fi

# Load local overrides if exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
# Fix NVIDIA EGL crash on Wayland - force X11 mode
export KITTY_DISABLE_WAYLAND=1

# Use kitty ssh integration automatically when inside Kitty
: ${KITTY_SSH_WRAP:=1}
if [[ ${KITTY_SSH_WRAP} -eq 1 ]] && [[ "$TERM" = xterm-kitty || -n "$KITTY_WINDOW_ID" ]] && command -v kitty >/dev/null 2>&1; then
  if ! typeset -f ssh >/dev/null 2>&1; then
    ssh() { kitty +kitten ssh "$@"; }
  fi
fi

# Fallback completion init if zinit/compinit not already handled
if ! typeset -f compinit >/dev/null 2>&1; then
  autoload -Uz compinit && compinit -C
fi

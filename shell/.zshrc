# Minimal zsh baseline managed by dotfiles.
# Machine-specific additions go in ~/.zshrc.local.

# Keep common user executables early in PATH.
export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"

# Shared conda policy helpers.
if [ -f "$HOME/.shell_conda_policy.sh" ]; then
  # shellcheck disable=SC1090
  . "$HOME/.shell_conda_policy.sh"
fi

# Enable mise if installed.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Enable conda if installed.
if command -v conda >/dev/null 2>&1; then
  eval "$(conda shell.zsh hook 2>/dev/null)"
  if command -v conda_policy_after_init >/dev/null 2>&1; then
    conda_policy_after_init
  fi
fi

# Local machine overrides (not tracked).
if [ -f "$HOME/.zshrc.local" ]; then
  # shellcheck disable=SC1090
  . "$HOME/.zshrc.local"
fi

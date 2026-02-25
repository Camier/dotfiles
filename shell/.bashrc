# shellcheck shell=bash
# Minimal bash baseline managed by dotfiles.
# Machine-specific additions go in ~/.bashrc.local.

# Keep common user executables early in PATH.
export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"

# Shared conda policy helpers.
if [ -f "$HOME/.shell_conda_policy.sh" ]; then
  # shellcheck disable=SC1090,SC1091
  . "$HOME/.shell_conda_policy.sh"
fi

# Enable mise if installed.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

# Enable conda if installed.
if command -v conda >/dev/null 2>&1; then
  eval "$(conda shell.bash hook 2>/dev/null)"
  if command -v conda_policy_after_init >/dev/null 2>&1; then
    conda_policy_after_init
  fi
fi

# Local machine overrides (not tracked).
if [ -f "$HOME/.bashrc.local" ]; then
  # shellcheck disable=SC1090,SC1091
  . "$HOME/.bashrc.local"
fi

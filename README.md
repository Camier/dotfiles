# Dotfiles — Conda/Mamba + Mise + Shell

GNU Stow-based dotfiles for conda/mamba + mise + shell configuration management.

**Location:** `/LAB/@infra/dotfiles`  
**Pattern:** Pure GNU Stow packages (XDG-friendly layout where needed)

---

## Quick Start

```bash
# Install all configs
cd /LAB/@infra/dotfiles
./install

# Verify installation
ls -la ~/.condarc  # Should symlink to /LAB/@infra/dotfiles/conda/
ls -la ~/.config/mise/config.toml  # Should symlink to /LAB/@infra/dotfiles/mise/.config/mise/config.toml
```

**Requirements:** GNU Stow (`sudo apt install stow`)

---

## Structure

| Package | Purpose | Key Files |
|---------|---------|-----------|
| `shell/` | Shell configs (Zsh/Bash) | `.zshrc`, aliases, PATH, conda policy |
| `conda/` | Conda/mamba configuration | `.condarc` (channels, solver, optimizations) |
| `mise/` | Mise toolchain | `.config/mise/config.toml` (Python, Node, CLI tools) |
| `git/` | Git configuration | `.gitconfig`, `.gitignore_global` |
| `bin/` | Custom scripts | `.local/bin/` for machine-specific binaries |

---

## Usage

```bash
# Install all
./install

# Install single package
./install conda

# Uninstall all
./install --uninstall

# List packages
./install --list
```

---

## Tool Boundaries

| Tool | Use Case | When to Use |
|------|----------|-------------|
| **mise** | Standalone Python, CLI tools | Web apps, scripts, ruff, black |
| **conda/mamba** | Data science, ML, compiled deps | NumPy, pandas, PyTorch, TensorFlow |

**Golden rule:** When both mise and conda manage Python, **conda takes precedence** when activated. Verify with `type -a python`.

---

## Machine-Specific Overrides

Use `~/.zshrc.local` or `~/.condarc.local` for machine-specific configs (not tracked in git). These are auto-sourced if present.

---

## Security Notes

- **NEVER COMMIT:** SSH keys, `.netrc`, `.npmrc` with tokens, `.git-credentials`
- **Use `~/.007/`** for secrets (SOPS-encrypted)
- **Use `~/` paths** instead of absolute `/home/miko/` paths

---

## See Also

- `AGENTS.md` — Repository guidelines for agents
- `/LAB/@doc` — Infrastructure documentation
- Original configs preserved in `~/.dotfiles-backup/` (created on first install)

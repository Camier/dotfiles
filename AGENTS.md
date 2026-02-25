# Repository Guidelines

## Project Purpose
Dotfiles repository for conda/mamba + mise + shell configuration management using **GNU Stow** (ThePrimeagen pattern).

Track portable shell/tool configurations; exclude machine-specific paths and secrets.

## Project Structure & Module Organization
- `shell/`: Shell configurations (`.zshrc`, `.bashrc`, aliases, functions, PATH setup)
- `conda/`: Conda/mamba configuration (`.condarc`, environment policies)
- `mise/`: Mise toolchain configuration (`.config/mise/config.toml`, tool versions)
- `git/`: Git configuration (`.gitconfig`, `.gitignore_global`)
- `bin/`: Custom scripts and aliases (`.local/bin/` for machine-specific binaries)
- `install`: GNU Stow wrapper script (idempotent install/uninstall)
- `README.md`: Setup instructions and tool boundaries documentation

## Setup, Build, Test, and Dev Commands
- **Install default configs**: `./install` (installs `shell`, `conda`, `mise`, `git`, `bin`)
- **Uninstall all configs**: `./install --uninstall` (runs `stow -D`)
- **Install single package**: `./install shell` or `./install conda`
- **Uninstall single package**: `./install --uninstall shell`
- **Verify symlinks**: `ls -la ~ | grep -E "^l"` (should point to `/LAB/@infra/dotfiles/`)
- **Update configs**: `git pull` in repo, symlinks auto-update

## Coding Style & Naming Conventions
- **Shell scripts**: POSIX `sh` compatible (no bashisms in shared configs)
- **Stow packages**: Use pure Stow naming (file paths match target paths under `$HOME`)
  - Example: `conda/.condarc` → `~/.condarc`
- **Directory names**: Match target dotfile name (e.g., `shell/` contains `.zshrc`, `.bashrc`)
- **Comments**: Use `# ============================================================================` section dividers for readability

## Testing Guidelines
- **Smoke test after install**: Open new shell, verify `conda --version`, `mise --version`
- **Verify PATH order**: `type -a python` should show expected priority
- **Test conda policy**: `pip install` in base env should be blocked
- **Validate symlinks**: `readlink ~/.condarc` should point to `/LAB/@infra/dotfiles/conda/.condarc`

## Data & Security Notes
- **DO NOT COMMIT**: 
  - `~/.ssh/` keys or configs
  - `~/.netrc`, `~/.npmrc` with tokens
  - `~/.git-credentials`
  - Machine-specific paths (`/home/miko/miniforge3` → use `~/miniforge3`)
  - Secrets (use `~/.007/` or environment variables)
- **Machine-specific overrides**: Use `~/.zshrc.local` or `~/.condarc.local` (sourced if exists, not tracked)

## Commit & Pull Request Guidelines
- **Semantic prefixes**: `feat` (new tool config), `fix` (broken symlink), `docs` (README updates), `chore` (gitignore)
- **Scope**: Include affected package in subject: `feat(conda): add solver_threads setting`
- **PR requirements**: 
  - List affected symlinks
  - Note installation commands (`stow conda`)
  - Mention breaking changes (e.g., "moves ~/.bashrc to shell/")

## Tool Boundaries (Quick Reference)

| Tool | Use Case | Config Location |
|------|----------|-----------------|
| **mise** | Standalone Python, CLI tools | `mise/.config/mise/config.toml` |
| **conda/mamba** | Data science, ML, compiled deps | `conda/.condarc` |
| **shell** | Bash/Zsh configs, aliases | `shell/` |

**Golden rule**: When both mise and conda manage Python, **conda takes precedence** when activated. Use `type -a python` to verify.

## Reality vs Plan Snapshot
- **Current**: Flat stow packages (`shell/`, `conda/`, `mise/`)
- **Planned**: XDG-compliant subdirs (`shell/.config/shell/`) for stricter separation
- **Current**: Pure stow layout (target path mirrored inside each package)
- **Planned**: Expand XDG coverage where helpful (`.config/<tool>/...`)

## Agent Workflow Tips
- **Check repo state**: `git status -sb` before editing
- **Verify symlinks**: After changes, run `./install` and check `ls -la ~`
- **Test in clean shell**: `bash --norc --noprofile` to verify no stale configs
- **Stow conflicts**: If `stow` fails, existing file blocks symlink → backup and retry

## Quick Start (New Machine)
```bash
# Clone repository
git clone https://github.com/Camier/dotfiles.git /LAB/@infra/dotfiles
cd /LAB/@infra/dotfiles

# Install GNU Stow (if missing)
# Ubuntu/Debian: sudo apt install stow
# macOS: brew install stow

# Install default configs
./install

# Verify
ls -la ~/.condarc  # Should symlink to /LAB/@infra/dotfiles/conda/
```

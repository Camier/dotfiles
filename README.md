Dotfiles
========

This repository contains a minimal, portable set of configuration files (dotfiles) and a bootstrap script to symlink them into your home directory.

What’s included
---------------
- Bash: aliases and quality-of-life tweaks loaded via `~/.bashrc.d/*`.
- Git: sane defaults and a global ignore file.
- EditorConfig: consistent whitespace and encoding rules.
- Inputrc: improved readline completion and navigation.
- Ripgrep: defaults for quick, useful searches.
- Vim: a minimal configuration suitable for servers.

Install
-------
Non-destructive: existing files are backed up to `~/.dotfiles_backup_<timestamp>`.

1) Review files in this repo and adjust as you like.
2) Run the installer:

   ./install.sh

3) Open a new shell or source your bash config:

   exec "$SHELL" -l

Uninstall
---------
Remove the symlinks created by the installer, then restore from the backup directory if desired.

Advanced
--------
- To add more files, mirror their desired target names under an appropriate subfolder and extend `install.sh` mapping.
- The installer uses simple symlinks and avoids external dependencies like GNU Stow.


## Nichijou Terminal (Kitty + Zsh + Starship)

This repo contains a stow-ready layout:

- `kitty/.config/kitty` (config, themes, sessions)
- `starship/.config/starship/starship.toml`
- `zsh/.zshrc`
- `bin/.local/bin` helper scripts (nichijou_motto, kitty_help, kitty_menu, kitty_ssh_prompt)

Install with GNU Stow:

```bash
cd ~/dotfiles
# stow all packages (kitty, starship, zsh, bin)
./scripts/bootstrap.sh
# or restow/unstow specific packages
./scripts/bootstrap.sh --restow kitty starship
./scripts/bootstrap.sh --unstow bin
```

Best practices

- Keep secrets and machine‑local overrides out of git:
  - `zsh/.zshrc.local`, `kitty/local.conf`, `starship/local.toml`, `bin/private/` are gitignored.
- Use Stow to manage symlinks cleanly; remove with `--unstow`.
- Validate after changes: `make check` (syntax + presence checks).
- Optional: enable pre‑commit hooks to lint shell scripts:
  ```bash
  pipx install pre-commit || pip install pre-commit
  pre-commit install
  ```

Right-click in Kitty to open the features menu; Ctrl+Shift+F1 opens the help overlay.

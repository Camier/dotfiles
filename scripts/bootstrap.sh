#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage: ${0##*/} [options] [packages...]

Options:
  -u, --unstow     Remove symlinks for packages
  -r, --restow     Restow packages (force re-link)
  -n, --dry-run    Show what would be done
  -h, --help       Show this help

Packages default: kitty starship zsh bin
USAGE
}

action=stow
dry=""
args=()
while (($#)); do
  case "$1" in
    -u|--unstow) action=unstow ;;
    -r|--restow) action=restow ;;
    -n|--dry-run) dry="-n" ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage; exit 1 ;;
    *) args+=("$1") ;;
  esac
  shift || true
done

DOTDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
PKGS=("${args[@]}")
if ((${#PKGS[@]}==0)); then PKGS=(kitty starship zsh bin); fi

if command -v stow >/dev/null 2>&1; then
  for p in "${PKGS[@]}"; do
    case "$action" in
      stow)   stow  $dry -vt "$HOME" "$p" -d "$DOTDIR" ;;
      restow) stow  $dry -Rvt "$HOME" "$p" -d "$DOTDIR" ;;
      unstow) stow  $dry -Dvt "$HOME" "$p" -d "$DOTDIR" ;;
    esac
  done
else
  echo "GNU stow not found; creating symlinks manually (no uninstall support)" >&2
  mkdir -p "$HOME/.config/kitty/themes" "$HOME/.config/kitty/sessions" "$HOME/.config/starship" "$HOME/.local/bin"
  ln -sf "$DOTDIR/kitty/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf" 2>/dev/null || true
  # Link all theme files and sessions (ignore if none)
  ln -sf "$DOTDIR/kitty/.config/kitty/themes"/* "$HOME/.config/kitty/themes/" 2>/dev/null || true
  ln -sf "$DOTDIR/kitty/.config/kitty/sessions"/* "$HOME/.config/kitty/sessions/" 2>/dev/null || true
  ln -sf "$DOTDIR/starship/.config/starship/starship.toml" "$HOME/.config/starship/starship.toml" 2>/dev/null || true
  ln -sf "$DOTDIR/zsh/.zshrc" "$HOME/.zshrc" 2>/dev/null || true
  ln -sf "$DOTDIR/bin/.local/bin"/* "$HOME/.local/bin/" 2>/dev/null || true
fi

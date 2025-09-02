#!/usr/bin/env bash
set -euo pipefail

this_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d%H%M%S)"

msg() { printf "[dotfiles] %s\n" "$*"; }
ensure_dir() { mkdir -p "$1"; }

link_file() {
  local src="$1" tgt="$2"
  ensure_dir "$(dirname -- "$tgt")"
  if [ -L "$tgt" ] && [ "$(readlink -f -- "$tgt")" = "$src" ]; then
    msg "ok  - $tgt already linked"
    return 0
  fi
  if [ -e "$tgt" ] || [ -L "$tgt" ]; then
    ensure_dir "$backup_dir"
    msg "mv  - $tgt -> $backup_dir/"
    mv -f -- "$tgt" "$backup_dir/"
  fi
  ln -s -- "$src" "$tgt"
  msg "ln  - $tgt -> $src"
}

# Map: repo path -> home target
declare -A FILES=(
  ["$this_dir/git/.gitconfig"]="$HOME/.gitconfig"
  ["$this_dir/git/.gitignore_global"]="$HOME/.gitignore_global"
  ["$this_dir/editorconfig/.editorconfig"]="$HOME/.editorconfig"
  ["$this_dir/inputrc/.inputrc"]="$HOME/.inputrc"
  ["$this_dir/ripgrep/.ripgreprc"]="$HOME/.ripgreprc"
  ["$this_dir/vim/.vimrc"]="$HOME/.vimrc"
)

for src in "${!FILES[@]}"; do
  link_file "$src" "${FILES[$src]}"
done

# Link all files under bash/.bashrc.d into ~/.bashrc.d
ensure_dir "$HOME/.bashrc.d"
for src in "$this_dir"/bash/.bashrc.d/*; do
  [ -e "$src" ] || continue
  tgt="$HOME/.bashrc.d/$(basename -- "$src")"
  link_file "$src" "$tgt"
done

msg "Done. Backups (if any) saved to: $backup_dir"


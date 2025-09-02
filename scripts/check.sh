#!/usr/bin/env bash
set -euo pipefail

ok=0; fail=0
note() { printf '\033[1;34m[info]\033[0m %s\n' "$*"; }
pass() { printf '\033[1;32m[ok]  \033[0m %s\n' "$*"; ((ok++)); }
err() { printf '\033[1;31m[err] \033[0m %s\n' "$*"; ((fail++)); }

# Symlinks
check_link() {
  local dst="$1"; shift
  if [ -L "$dst" ] || [ -L "$(dirname "$dst")" ]; then
    pass "link: $dst"
  else
    err "missing link: $dst"
  fi
}

note "Checking symlinks (if stowed)"
check_link "$HOME/.config/kitty/kitty.conf"
check_link "$HOME/.config/starship/starship.toml"
check_link "$HOME/.zshrc"

note "Checking helper scripts executability"
for s in nichijou_motto kitty_help kitty_menu kitty_ssh_prompt; do
  if [ -x "$HOME/.local/bin/$s" ]; then pass "bin: $s"; else err "bin missing/not exec: $s"; fi
done

note "Validating configs"
if starship print-config >/dev/null 2>&1; then pass "starship config"; else err "starship config"; fi
if /bin/zsh -n "$HOME/.zshrc" >/dev/null 2>&1; then pass "zsh syntax"; else err "zsh syntax"; fi

printf '\nSummary: %d ok, %d errors\n' "$ok" "$fail"
exit $(( fail>0 ))

# Contributing

## Workflow

1. Create a branch from `main`.
2. Make focused changes with clear commit messages.
3. Run local validation before pushing.
4. Open a pull request with affected packages and validation notes.

## Local Validation

From repo root:

```bash
bash -n install
./install --list

# Run install against an isolated target (no changes to $HOME)
tmp="$(mktemp -d)"
STOW_TARGET="$tmp" ./install conda mise shell git bin
find "$tmp" -maxdepth 5 -type l | sort
```

## Commit Style

Use semantic prefixes:

- `feat(<package>): ...`
- `fix(<package>): ...`
- `docs: ...`
- `chore: ...`

Examples:

- `fix(install): target HOME by default`
- `docs: update pure stow package layout`

## Push Note (Credential Collision)

If push fails with HTTP `403` while `gh auth status` shows you are logged in, the environment `GITHUB_TOKEN` may override your normal Git credentials.

Use:

```bash
env -u GITHUB_TOKEN git push
```

## Security

- Do not commit secrets, tokens, SSH keys, or machine-specific credentials.
- Prefer `~/` paths over absolute user paths in tracked configs.

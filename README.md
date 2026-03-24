# Dotfiles

My personal dotfiles, managed with [chezmoi](https://chezmoi.io/).

## Features

- **XDG Base Directory compliant** - Keeps `$HOME` clean
- **Shell**: Zsh with zinit, Powerlevel10k, syntax highlighting
- **Secrets**: 1Password integration for SSH keys and SOPS encryption
- **macOS-focused**: Homebrew, iTerm2, Alfred configurations

## Structure

| Location | Purpose |
|----------|---------|
| `~/.config/zsh/.zshrc` | Zsh interactive config |
| `~/.config/git/config` | Git configuration |
| `~/.config/homebrew/Brewfile` | Homebrew packages |
| `~/.zshenv` | Environment variables (XDG, PATH) |
| `~/.local/shell/.aliases` | Custom aliases and functions |

## Installation

### Cold Start (bare new machine — no brew/git/1Password/SSH keys)

**Step 1 — Xcode CLI tools** (provides `git`, `curl`, `ssh`)
```bash
xcode-select --install
```

**Step 2 — Homebrew**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Step 3 — Restore from rsync backup** (no SSH keys or 1Password needed yet)
```bash
# Mount the Samba share (LAN only — must be on 192.168.1.0/24)
# Password: stored in 1Password "elsevier-mac samba"
open smb://darshan@192.168.1.225/elsevier-mac

# Grab the temporary migration SSH key — from the share, or 1Password if unavailable
cp /Volumes/elsevier-mac/migration_key ~/.ssh/migration_key
# fallback: op read "op://homelab/migration-temp-key/notesPlain" > ~/.ssh/migration_key
chmod 600 ~/.ssh/migration_key

# Rsync everything back using the temp key
# --no-owner --no-group: assign files to current user regardless of stored UID
rsync -avzP --no-owner --no-group \
  -e "ssh -i ~/.ssh/migration_key -o IdentitiesOnly=yes" \
  root@192.168.1.215:/tank/elsevier-mac/home/ /Users/rambhiad/
```

> At this point `~/.local/share/chezmoi` is already restored from the backup.

**Step 4 — 1Password** (install now, after files are restored)

Download and install manually from https://1password.com/downloads/mac/

Then: sign in → Settings → Developer → enable SSH Agent

**Step 5 — Apply dotfiles**
```bash
brew install chezmoi
chezmoi apply
```

**Step 6 — Install all packages**
```bash
brew bundle --file=~/.config/homebrew/Brewfile
```

> **Managed Mac (can't write to `/Applications`):** Use `~/Applications` instead:
> ```bash
> HOMEBREW_CASK_OPTS="--appdir=~/Applications" brew bundle --file=~/.config/homebrew/Brewfile
> ```

**Step 7 — Post-install** (see APPS.md for manual installs)
```bash
# Restore PopClip extensions
popclip-restore
# Import iTerm2 profile from ~/.config/iterm2/
# Import Alfred preferences from ~/.config/alfred/
```

---

### New Machine (no existing backup — fresh from git)

```bash
# Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply darshan-rambhia

# Install Homebrew packages
brew bundle --file=~/.config/homebrew/Brewfile
```

### Existing Machine

```bash
chezmoi init darshan-rambhia
chezmoi diff  # Review changes
chezmoi apply
```

## Key Tools

- **chezmoi** - Dotfiles manager
- **1Password CLI** - Secrets management
- **SOPS + age** - Encrypted files (key in 1Password)
- **zinit** - Fast Zsh plugin manager

## Custom Commands

| Command | Description |
|---------|-------------|
| `openfiles` | Show processes with most open file descriptors |
| `popclip-backup` | Backup PopClip extensions |
| `popclip-restore` | Restore PopClip extensions |

## License

MIT

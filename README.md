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

**Step 2 — 1Password** (needed for SSH keys and encrypted secrets)

Download and install manually from https://1password.com/downloads/mac/

Then: sign in → Settings → Developer → enable SSH Agent

**Step 3 — Homebrew**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Step 4 — Restore from rsync backup** (if migrating from old machine)
```bash
# Mount the share first (LAN only — must be on 192.168.1.0/24)
open smb://darshan@192.168.1.225/elsevier-mac

# Then rsync back (SSH path, no SMB needed)
rsync -avzP root@homelab:/tank/elsevier-mac/home/ /Users/rambhiad/
```

> At this point `~/.local/share/chezmoi` is already restored from the backup.

**Step 5 — Apply dotfiles**
```bash
brew install chezmoi
chezmoi apply
```

**Step 6 — Install all packages**
```bash
brew bundle --file=~/.config/homebrew/Brewfile
```

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

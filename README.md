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

### New Machine

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

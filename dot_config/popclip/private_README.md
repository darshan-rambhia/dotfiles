# PopClip Extensions Backup

This folder contains a backup of PopClip extensions for tracking with chezmoi.

PopClip stores extensions in `~/Library/Application Support/PopClip/Extensions/`, but we keep a copy here in `~/.config/popclip/` so chezmoi can track them in one central location.

## Commands

| Command | Description |
|---------|-------------|
| `popclip-backup` | Copy extensions from PopClip to here, then update chezmoi |
| `popclip-restore` | Copy extensions from here to PopClip (for new machines) |

## Workflow

### On a new machine

```bash
chezmoi apply      # pulls this folder
popclip-restore    # copies to ~/Library/Application Support/PopClip/
# restart PopClip
```

### After installing new extensions

```bash
popclip-backup     # copies here + updates chezmoi
```

## Installed Extensions

- Alfred
- Audible
- Base64
- Calculate
- Call
- Character Count
- Google Search
- Jira (custom)
- Raycast
- Terminal
- Urban Dictionary
- Word Count

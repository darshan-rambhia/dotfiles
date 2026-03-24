# Manual App Installations

Apps not available via Homebrew or Mac App Store that require manual installation.

## Work/Enterprise Apps

| App | Source | Notes |
|-----|--------|-------|
| Company Portal | [Microsoft Intune](https://go.microsoft.com/fwlink/?linkid=853070) | MDM enrollment |
| Self Service | Jamf | Installed via MDM |
| Jamf Connect | Jamf | Installed via MDM |
| Falcon | [CrowdStrike](https://www.crowdstrike.com/) | Enterprise security, installed via IT |
| BeyondTrust | IT | Privilege management, pushed via MDM |
| PrivilegeManagement | IT | Pushed via MDM |
| Zscaler | IT | Network security proxy, pushed via IT |
| Microsoft Word | IT / MDM | May come via company portal or `brew install --cask microsoft-word` |

## Third-Party Apps

| App | Source | Notes |
|-----|--------|-------|
| Kiro CLI | [Amazon Kiro](https://kiro.dev/) | AI coding assistant |
| Boom 3D | [Global Delight](https://www.globaldelight.com/boom/) | Audio enhancer (App Store has extension only) |
| Antigravity | - | Custom/Unknown |
| CrisisGo | [CrisisGo](https://www.crisisgo.com/) | Safety platform |
| Florix | - | Custom/Unknown |
| OpenLauncher | - | Custom/Unknown |
| Syntax Highlight | [GitHub](https://github.com/sbarex/SourceCodeSyntaxHighlight) | Quick Look plugin (also available via `brew install --cask syntax-highlight`) |

## Notes

- **MDM Apps**: Company Portal, Self Service, Jamf Connect, and Falcon are typically pushed via corporate MDM
- **Boom 3D**: Main app from website, Netflix extension from App Store
- Apps marked with `-` may be custom builds or no longer available

## Post-Install Steps

After installing apps:

1. Run `popclip-restore` to restore PopClip extensions
2. Sign into 1Password to restore SSH keys and secrets
3. Import iTerm2 profile from `~/.config/iterm2/`
4. Import Alfred preferences from `~/.config/alfred/`

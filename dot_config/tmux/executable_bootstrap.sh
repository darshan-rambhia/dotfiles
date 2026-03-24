#!/usr/bin/env bash
# Bootstrap script for tmux plugin manager

TPM_DIR="$HOME/.tmux/plugins/tpm"

# Install TPM if not present
if [ ! -d "$TPM_DIR" ]; then
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    "$TPM_DIR/bin/install_plugins"
fi

# Run TPM
"$TPM_DIR/tpm"

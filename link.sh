#!/usr/bin/env bash
set -euo pipefail

# Create all dotfile symlinks. Safe to re-run; existing real files are
# backed up to <file>.bak before linking. Run this after cloning the repo
# (see README.md). Works no matter where the repo is cloned.

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Link $1 (in repo) to $2 (destination), backing up any existing real file.
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backing up $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "  linked $dst"
}

echo "Linking dotfiles from $REPO"
link "$REPO/zshrc"                "$HOME/.zshrc"
link "$REPO/zprofile"             "$HOME/.zprofile"
link "$REPO/gitconfig"            "$HOME/.gitconfig"
link "$REPO/latexmkrc"            "$HOME/.latexmkrc"
link "$REPO/claude/settings.json" "$HOME/.claude/settings.json"
link "$REPO/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
link "$REPO/sublime/User"         "$HOME/Library/Application Support/Sublime Text/Packages/User"
echo "Done."

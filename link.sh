#!/usr/bin/env bash
set -euo pipefail

# Create all dotfile symlinks. Safe to re-run; existing non-symlinks are
# backed up before linking. Run this after cloning the repo (see README.md).
# Works no matter where the repo is cloned.

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Link $1 (in repo) to $2 (destination), backing up any existing non-symlink.
link() {
  local src="$1" dst="$2"
  local backup suffix timestamp
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    timestamp="$(date '+%Y%m%d-%H%M%S')"
    backup="$dst.bak.$timestamp"
    suffix=1
    while [ -e "$backup" ] || [ -L "$backup" ]; do
      backup="$dst.bak.$timestamp.$suffix"
      suffix=$((suffix + 1))
    done
    echo "  backing up $dst -> $backup"
    mv "$dst" "$backup"
  fi
  ln -sfn "$src" "$dst"
  echo "  linked $dst"
}

echo "Linking dotfiles from $REPO"
link "$REPO/zshrc"                "$HOME/.zshrc"
link "$REPO/zprofile"             "$HOME/.zprofile"
link "$REPO/zshenv"               "$HOME/.zshenv"
link "$REPO/gitconfig"            "$HOME/.gitconfig"
link "$REPO/latexmkrc"            "$HOME/.latexmkrc"
link "$REPO/claude/settings.json" "$HOME/.claude/settings.json"
link "$REPO/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
link "$REPO/sublime/User"         "$HOME/Library/Application Support/Sublime Text/Packages/User"
echo "Done."

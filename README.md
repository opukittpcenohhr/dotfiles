# dotfiles

Personal macOS setup. Configs live in this repo; `~/.zshrc`, `~/.gitconfig`,
VS Code settings, etc. are symlinks pointing back here.

## Setting up a new machine

Run these once, in order.

### 1. Install Xcode Command Line Tools

Provides `git` (needed for the next step) and `clang`/`g++`.

```sh
xcode-select --install
```

Wait for the GUI installer to finish before continuing.

### 2. Clone this repo

```sh
git clone https://github.com/opukittpcenohhr/dotfiles.git ~/Desktop/dotfiles
cd ~/Desktop/dotfiles
```

The remaining commands are run from the repo root.

> Cloning over **HTTPS** here avoids a chicken-and-egg problem: the SSH remote
> needs keys that don't exist yet on a fresh machine. Switch the remote to SSH
> later if you want: `git remote set-url origin git@github.com:opukittpcenohhr/dotfiles.git`

### 3. Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then load it into the current shell (Apple Silicon):

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
```

(Step 6 links `~/.zprofile`, which runs this automatically in future shells.)

### 4. Install packages

Installs everything in the `Brewfile`: CLI tools, casks (apps), VS Code
extensions, and `uv` tools.

```sh
brew bundle
```

### 5. Install oh-my-zsh

Follow the current instructions at <https://ohmyz.sh>.

### 6. Link the dotfiles

Creates all symlinks. Any existing real file is backed up to `<file>.bak`
first. Safe to re-run.

```sh
./link.sh
```

### 7. Restart your shell

```sh
exec zsh
```

## Notes

- **Python:** managed with `uv` (installed via the Brewfile). It fetches and
  pins Python versions per project, so there's nothing extra to set up.

- **iTerm2:** settings live in `iterm2/`. On a new machine, open iTerm2 →
  Settings → General → Preferences, check "Load preferences from a custom
  folder or URL", point it at this repo's `iterm2/` folder, and set "Save
  changes" to *Automatically*. iTerm2 reads/writes the plist there itself, so
  it isn't symlinked by `link.sh`.

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

(Step 7 links `~/.zprofile`, which runs this automatically in future shells.)

### 4. Install Rust

Follow the current instructions at <https://rustup.rs>, adding
`--no-modify-path` — `zshenv` already puts `~/.cargo/bin` on PATH.

### 5. Install packages

Installs everything in the `Brewfile`: CLI tools, casks (apps), etc.

```sh
source "$HOME/.cargo/env"  # this shell only; step 7 links zshenv, which puts it on PATH for good
brew bundle
```

> The `Brewfile` has `cargo` entries, so `cargo` must be on PATH here — hence
> the `source` line, since step 4 used `--no-modify-path`. Without it `brew
> bundle` installs Homebrew's `rust` formula, which then shadows `rustup`'s
> toolchain on PATH.

### 6. Install oh-my-zsh

Follow the current instructions at <https://ohmyz.sh>.

### 7. Link the dotfiles

Creates all symlinks. Any existing real file is backed up to `<file>.bak`
first. Safe to re-run.

```sh
./link.sh
```

### 8. Point iTerm2 at this repo

iTerm2 keeps its own plist and can't be symlinked by `link.sh` — it reads and
writes the file itself. Instead, open iTerm2 → Settings → General →
Preferences, check "Load preferences from a custom folder or URL", point it at
this repo's `iterm2/` folder, and set "Save changes" to *Automatically*.

### 9. Restart your shell

```sh
exec zsh
```

## Installed directly

The things installed on the machine by hand, outside of anything else.
Everything not listed here is managed by one of them (e.g. `uv` and VS Code
extensions are managed by Homebrew).

**Xcode Command Line Tools**
- *Owns:* `git`, `clang`/`g++`, and the macOS SDK everything else builds against
- *Update:* through macOS software updates

**Homebrew**
- *Owns:* CLI tools, casks (apps), VS Code extensions, `uv` tools, `cargo` binaries
- *Brewfile:* generated, not hand-edited — see "Keeping the repo in sync"
- *Update:* `brew update && brew bundle upgrade` from the repo root — unlike
  `brew upgrade`, it also covers the `vscode`, `uv` and `cargo` entries

**rustup**
- *Owns:* Rust toolchains (`rustc`, `cargo`)
- *Why not Homebrew:* `rustup` is the officially recommended way to install
  Rust (<https://rustup.rs>)
- *Update:* `rustup update`

**oh-my-zsh**
- *Owns:* the zsh framework and its plugins
- *Update:* `omz update`

## Keeping the repo in sync

Configs stay in sync on their own — edits land here as a diff to commit. The
exceptions:

- **Installed packages.** The `Brewfile` is a snapshot; re-take it with
  `brew bundle dump --force` from the repo root after changing anything.

- **New config files.** Add a `link` line to `link.sh` and re-run it.

## Notes

- **VS Code settings:** `vscode/settings.json` holds personal defaults, not a
  safe common denominator — format-on-save is on globally, with a formatter
  pinned per language. A project needing anything different overrides it in its
  own committed `.vscode/settings.json`, which beats user settings — for
  example, disabling `latexindent` on a shared paper.

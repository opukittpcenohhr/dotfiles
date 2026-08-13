# uv
export PATH="$HOME/.local/bin:$PATH"

# dotfiles bin
DOTFILES="${${(%):-%x}:A:h}"
export PATH="$DOTFILES/bin:$PATH"

# rust (rustup: cargo, rustc, rustup itself)
export PATH="$HOME/.cargo/bin:$PATH"

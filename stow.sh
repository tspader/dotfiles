[[ -f "$HOME/.bashrc" ]] && rm "$HOME/.bashrc"

[[ -f "$HOME/.profile" ]] && rm "$HOME/.profile"

stow alacritty
stow bash
stow gdb
stow lsd
stow neovim
stow opencode
stow ssh
stow tmux
stow --target / keyd

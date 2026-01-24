[[ -f "$HOME/.bashrc" ]] && rm "$HOME/.bashrc"

[[ -f "$HOME/.profile" ]] && rm "$HOME/.profile"

stow alacritty
stow bash
stow claude
stow gdb
stow ghostty
stow lsd
stow nchat
stow neovim
stow opencode
stow pass
stow sp
stow ssh
stow tmux
stow wezterm
stow yazi

#stow --target / keyd

[[ -f "$HOME/.config/alacritty/alacritty.local.toml" ]] && cp "$HOME/.config/alacritty/alacritty.local.toml.template" "$HOME/.config/alacritty/alacritty.local.toml"

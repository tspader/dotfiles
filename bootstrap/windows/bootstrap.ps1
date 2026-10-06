reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v AllowDevelopmentWithoutDevLicense /d 1
choco install -y git wezterm pwsh nerd-fonts-iosevka bun

choco install -y caffeine nanazip tailscale neovim delta lazygit yazi ripgrep fd cmake ninja msys2 llvm rustup.install python nodejs-lts zig

cargo install tree-sitter-cli

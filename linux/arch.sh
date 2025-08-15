#!/bin/bash
pacman -S --needed \
  base-devel \
  cmake \
  curl \
  docker \
  docker-compose \
  fzf \
  gdb \
  gnupg \
  less \
  lsof \
  luajit \
  neovim \
  nodejs \
  openssh \
  python \
  uv \
  ripgrep \
  stow \
  tmux \
  tree \
  unzip \
  xclip

# Dotfiles
if [ ! -d "$HOME/.dotfiles" ]; then
  git clone https://github.com/spaderthomas/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  ./stow.sh
  source ~/.bashrc

  git remote set-url origin git@github.com:spaderthomas/dotfiles.git
  git remote push.autoSetupRemote true
  git config --global user.name "Thomas Spader"
  git config --global user.email ""
fi

# SSH
[ ! -f ~/.ssh/id_ed25519 ] && ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
systemctl enable --now sshd

# AUR
if ! id "spader" &>/dev/null; then
    useradd -m -G wheel -s /bin/bash spader
    # Enable passwordless sudo for wheel group
    echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
fi

if ! command -v yay &>/dev/null; then
    su - spader -c "
        if [ ! -d ~/yay ]; then
            git clone https://aur.archlinux.org/yay.git ~/yay
            cd ~/yay && makepkg -si --noconfirm
            yay -S --noconfirm tailscale
        fi
    "
fi

# Tailscale
systemctl enable --now tailscaled
tailscale up

# Docker
systemctl enable --now docker

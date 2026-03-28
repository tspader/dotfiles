#!/bin/bash
sudo pacman -S --needed --noconfirm \
  avahi \
  base-devel \
  curl \
  gnupg \
  less \
  linux-headers \
  lsof \
  man \
  nss-mdns \
  openssh \
  reflector \
  rsync \
  wget

sudo pacman -S --verbose --needed --noconfirm \
  cifs-utils \
  docker \
  docker-compose \
  extra/bind \
  fzf \
  gdb \
  httpie \
  lazygit \
  lsd \
  luajit \
  lua-language-server \
  neovim \
  nodejs \
  ouch \
  python \
  reflector \
  ripgrep \
  rsync \
  stow \
  tmux \
  tree \
  usbutils \
  uv \
  xdg-user-dirs
if [ ! -d "$HOME/.dotfiles" ]; then
  git clone https://github.com/tspader/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles

  git remote set-url origin git@github.com:tspader/dotfiles.git
  git remote push.autoSetupRemote true
  git config --global user.name "Thomas Spader"
  git config --global user.email ""
fi

if ! command -v yay &>/dev/null; then
   if [ ! -d ~/yay ]; then
       git clone https://aur.archlinux.org/yay.git ~/yay
       cd ~/yay && makepkg -si --noconfirm
   fi
fi

yay -S --needed --noconfirm tailscale

if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N \"\"
  cat ~/.ssh/id_ed25519.pub >> ~/.dotfiles/ssh/.ssh/authorized_keys
fi

xdg-user-dirs-update

sudo systemctl enable --now \
  sshd \
  tailscaled \
  docker \
  avahi-daemon

sudo tailscale up

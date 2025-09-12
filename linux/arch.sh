#!/bin/bash
. "$(dirname "$0")/sp.sh"

sp_arch_step() {
  sp_color $SP_BRIGHT_CYAN ">> "
  sp_color $SP_BRIGHT_YELLOW "$1 "
  sp_color $SP_BRIGHT_BLACK "$2"
  sp_tui_new_line
}

sp_arch_step "pacman" "base packages"
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
sp_tui_new_line

sp_arch_step "pacman" "development packages"
sudo pacman -S --verbose --needed --noconfirm \
  cifs-utils \
  docker \
  docker-compose \
  extra/bind \
  fzf \
  gdb \
  httpie \
  lazygit \
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
sp_tui_new_line

sp_arch_step "git" "clone dotfiles"
if [ ! -d "$HOME/.dotfiles" ]; then
  git clone https://github.com/tspader/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles

  git remote set-url origin git@github.com:tspader/dotfiles.git
  git remote push.autoSetupRemote true
  git config --global user.name "Thomas Spader"
  git config --global user.email ""
fi
sp_tui_new_line

sp_arch_step "stow" "stow dotfiles"
./stow.sh
source ~/.bashrc
sp_tui_new_line


sp_arch_step "yay" "clone and install yay"
if ! command -v yay &>/dev/null; then
   if [ ! -d ~/yay ]; then
       git clone https://aur.archlinux.org/yay.git ~/yay
       cd ~/yay && makepkg -si --noconfirm
   fi
fi
sp_tui_new_line

sp_arch_step "yay" "install tailscale"
yay -S --needed --noconfirm tailscale
sp_tui_new_line

sp_arch_step "ssh" "generate ssh key"
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N \"\"
  cat ~/.ssh/id_ed25519.pub >> ~/.dotfiles/ssh/.ssh/authorized_keys
fi
sp_tui_new_line

sp_arch_step "xdg" "update xdg directories"
xdg-user-dirs-update
sp_tui_new_line

sp_arch_step "systemd" "enable systemd services"
sudo systemctl enable --now \
  sshd \
  tailscaled \
  docker \
  avahi-daemon
sp_tui_new_line

sp_arch_step "tailscale" "start tailscale"
sudo tailscale up
sp_tui_new_line

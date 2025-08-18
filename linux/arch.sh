#!/bin/bash
pacman -S --needed \
  base-devel \
  cifs-utils \
  cmake \
  curl \
  docker \
  docker-compose \
  extra/bind \
  fzf \
  gdb \
  gnupg \
  httpie \
  mullvad-vpn \
  keyd \
  lazygit \
  less \
  linux-headers \
  lsof \
  luajit \
  neovim \
  nodejs \
  openssh \
  ouch \
  python \
  reflector \
  ripgrep \
  rsync \
  stow \
  tealdeer \
  tmux \
  trash \
  tree \
  usbutils \
  uv \
  wget \
  yazi


pacman -S --needed \
  plasma-meta
  xdg-user-dirs \
  pipewire \
  pipewire-alsa \
  pipewire-pulse \
  pipewire-jack \
  wireplumber \
  alacritty \
  spectacle \
  ly \
  okular \
  firefox \
  chromium

xdg-user-dirs-update

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


if ! id "spader" &>/dev/null; then
    useradd -m -G wheel -s /bin/bash spader
    echo "%wheel ALL=(ALL:ALL): ALL" >> /etc/sudoers
fi

su spader bash -c "
  # AUR
  if ! command -v yay &>/dev/null; then
     if [ ! -d ~/yay ]; then
         git clone https://aur.archlinux.org/yay.git ~/yay
         cd ~/yay && makepkg -si --noconfirm
     fi
  fi

  yay -S --noconfirm \
    tailscale

  # SSH
  [ ! -f ~/.ssh/id_ed25519 ] && ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N \"\"
"
# systemd
systemctl enable --now \
  bluetooth \
  sshd \
  tailscaled \
  docker

systemctl --user enable --now \
  pipewire \
  pipewire-pulse \
  wireplumber

tailscale up

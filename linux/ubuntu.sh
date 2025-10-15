#!/bin/bash

. ./sp.sh

sp_install_ubuntu() {
  apt update

  sp_ensure_dependency apt curl
  sp_ensure_dependency apt fzf
  sp_ensure_dependency apt less
  sp_ensure_dependency apt lsof
  sp_ensure_dependency apt neovim
  sp_ensure_dependency apt openssh-server
  sp_ensure_dependency apt python3
  sp_ensure_dependency apt python3-pip
  sp_ensure_dependency apt ripgrep
  sp_ensure_dependency apt stow
  sp_ensure_dependency apt tmux
  sp_ensure_dependency apt tree
  sp_ensure_dependency apt unzip

  # Install uv via pip
  pip3 install uv

  # Dotfiles
  if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/spaderthomas/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ./stow.sh
    source ~/.bashrc
  fi

  # SSH
  [ ! -f ~/.ssh/id_ed25519 ] && ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
  systemctl enable --now ssh

  # Tailscale
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.list | tee /etc/apt/sources.list.d/tailscale.list
  apt update
  sp_ensure_dependency apt tailscale
  systemctl enable --now tailscaled

  tailscale up
}

main() {
  distro=$(sp_detect_distro)
  case "$distro" in
    ubuntu)
      sp_install_ubuntu
      ;;
    *)
      echo "Unsupported distro: $distro" >&2
      return 1
      ;;
  esac
}

main "$@"

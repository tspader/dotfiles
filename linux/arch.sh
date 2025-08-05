#!/bin/bash
pacman -S --needed \
  base-devel \
  cmake \
  curl \
  docker \
  fzf \
  gdb \
  gnupg \
  less \
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
  unzip

if [ ! -d "$HOME/.dotfiles" ]; then
  git clone https://github.com/spaderthomas/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  ./stow.sh
  source ~/.bashrc
fi

[ ! -f ~/.ssh/id_ed25519 ] && ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""

sudo apt update

sudo apt install -y \
  curl \
  fzf \
  less \
  lsof \
  neovim \
  openssh-server \
  python3 \
  python3-pip \
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

curl -LsSfk https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv tool update-shell

[ ! -f ~/.ssh/id_ed25519 ] && ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
systemctl enable --now ssh

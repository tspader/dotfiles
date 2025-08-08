apt update

apt install -y \
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

# Install uv via pip
pip3 install uv

# Dotfiles
if [ ! -d "$HOME/.dotfiles" ]; then
  git clone https://github.com/spaderthomas/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  ./stow.sh
  source ~/.bashrc
fi

curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool update-shell
source ~/.bashrc

# SSH
[ ! -f ~/.ssh/id_ed25519 ] && ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
systemctl enable --now ssh

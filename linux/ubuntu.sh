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


# SSH
[ ! -f ~/.ssh/id_ed25519 ] && ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
systemctl enable --now ssh

# Tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.list | tee /etc/apt/sources.list.d/tailscale.list
apt update
apt install -y tailscale
systemctl enable --now tailscaled

tailscale up

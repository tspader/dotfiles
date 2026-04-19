sudo pacman -S --needed \
  plasma-meta
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

sudo systemctl --user enable --now \
  bluetooth \
  pipewire \
  pipewire-pulse \
  wireplumber


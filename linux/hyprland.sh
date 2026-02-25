#!/bin/bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hyprland-test"
state_file="$state_dir/pacman-installed.txt"
repo_packages=(
  alacritty
  hyprland
  waybar
  hyprpicker
  grim
  slurp
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
  hyprpolkitagent
  qt5-wayland
  qt6-wayland
  jq
  wl-clipboard
  libqalculate
)
aur_packages=(
  walker
  elephant
  elephant-calc
  elephant-clipboard
  elephant-bluetooth
  elephant-desktopapplications
  elephant-files
  elephant-menus
  elephant-providerlist
  elephant-runner
  elephant-symbols
  elephant-unicode
  elephant-websearch
)

if lspci | grep -qi "NVIDIA"; then
  if ! pacman -Q nvidia-open >/dev/null 2>&1 && ! pacman -Q nvidia-open-dkms >/dev/null 2>&1 && ! pacman -Q nvidia >/dev/null 2>&1 && ! pacman -Q nvidia-dkms >/dev/null 2>&1; then
    printf "No supported NVIDIA kernel driver package is installed.\n"
    exit 1
  fi
  repo_packages+=(nvidia-utils egl-wayland)
fi

missing_repo=()
for pkg in "${repo_packages[@]}"; do
  pacman -Q "$pkg" >/dev/null 2>&1 || missing_repo+=("$pkg")
done

missing_aur=()
for pkg in "${aur_packages[@]}"; do
  pacman -Q "$pkg" >/dev/null 2>&1 || missing_aur+=("$pkg")
done

if ((${#missing_repo[@]})); then
  sudo pacman -S --needed "${missing_repo[@]}"
fi

if ((${#missing_aur[@]})); then
  if command -v paru >/dev/null 2>&1; then
    paru -S --needed "${missing_aur[@]}"
  else
    printf "paru is required to install AUR packages: %s\n" "${missing_aur[*]}"
    exit 1
  fi
fi

export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
export PATH="$BUN_INSTALL/bin:$PATH"

if ! command -v bun >/dev/null 2>&1; then
  curl -fsSL https://bun.com/install | bash
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

if [[ -d "$repo_dir/dottpl" ]]; then
  bun install --cwd "$repo_dir/dottpl"
  bun link --cwd "$repo_dir/dottpl"

  bun run --cwd "$repo_dir/dottpl" src/index.ts render "$repo_dir/hyprland"
fi

mkdir -p "$state_dir"
touch "$state_file"
for pkg in "${missing_repo[@]}" "${missing_aur[@]}"; do
  if ! grep -qx "$pkg" "$state_file"; then
    printf "%s\n" "$pkg" >>"$state_file"
  fi
done

if command -v stow >/dev/null 2>&1; then
  stow --dir "$repo_dir" --target "$HOME" hyprland
  stow --dir "$repo_dir" --target "$HOME" bin
  stow --dir "$repo_dir" --target "$HOME" icons
fi

if ! id "spader" &>/dev/null; then
  sudo useradd -m -G wheel -s /bin/bash spader
  echo "%wheel ALL=(ALL:ALL): ALL" >> /etc/sudoers
fi

#!/bin/bash

packages=(
  "curl"
  "alacritty"
  "git"
  "vim"
  "neovim"
)

install_debian_based() {
  echo "Detected Debian/Ubuntu-based system"
  sudo apt update
  sudo apt install -y "${packages[@]}"
}

install_fedora_based() {
  echo "Detected Fedora-based system"
  sudo dnf install -y "${packages[@]}"
}

install_arch_based() {
  echo "Detected Arch-based system"
  sudo pacman -Syu --noconfirm "${packages[@]}"
}

detect_package_manager() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
      "ubuntu" | "debian")
        install_debian_based
        ;;
      "fedora")
        install_fedora_based
        ;;
      "arch")
        install_arch_based
        ;;
      *)
        echo "Unsupported distribution: $ID"
        exit 1
        ;;
    esac
  else
    echo "Could not detect OS distribution."
    exit 1
  fi
}

setup_configuration() {
  echo "Setting up user configuration..."
  cp ~/dotfiles/.vimrc ~/.vimrc
  chsh -s $(which alacritty)
  # Add more configuration steps as needed
}

echo "Detecting package manager..."
detect_package_manager

echo "Setting up configuration..."
setup_configuration

echo "Setup complete!"

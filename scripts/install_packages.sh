#!/bin/bash

source ./logs/logging.sh
source ./utils/check_os.sh

install_flatpak() {
  log_info "Installing Flatpak..."
  if is_deb_system; then
    sudo apt-get install -y flatpak && log_success "Flatpak installed successfully!"
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm flatpak && log_success "Flatpak installed successfully!"
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y flatpak && log_success "Flatpak installed successfully!"
  else
    log_error "Flatpak installation failed."
    return 1
  fi
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && log_success "Repositório Flathub adicionado!"
}

install_snap(){
  if is_deb_system; then
  log_info "Installing Snap..."
    sudo apt-get install -y snapd && log_success "Snap installed successfully!"
  else
    sudo pacman -S --noconfirm snapd || sudo dnf install -y snapd && log_success "Snap installed successfully!"
  fi
}
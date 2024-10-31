#!/bin/bash

source ./logs/logging.sh
source check_os.sh

system_update(){
  log_info "Updating the system..."
  if is_deb_system; then
    sudo apt-get update && sudo apt-get upgrade -y && log_success "System updated!"
  else
    if command -v pacman &> /dev/null; then
      sudo pacman -Syu --noconfirm && log_success "System updated!"
    elif command -v dnf &> /dev/null; then
      sudo dnf update -y && log_success "System updated!"
    else
      log_warning "Package manager not supported for updating the system."
    fi
  fi
}
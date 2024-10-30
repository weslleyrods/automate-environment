#!/bin/bash
source ./logs/logging.sh

function remove_apps() {
  while IFS= read -r app; do
    if dpkg -l | grep -q "$app"; then
      sudo apt-get remove -y "$app"
      log_success "Debian app removed: $app"
    elif flatpak list | grep -q "$app"; then
      flatpak uninstall -y "$app"
      log_success "Flatpak app removed: $app"
    elif snap list | grep -q "$app"; then
      sudo snap remove "$app"
      log_success "Snap app removed: $app"
    else
      log_info "App not found: $app"
    fi
  done < ./config/remove_apps.txt
}

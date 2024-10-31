#!/bin/bash
source ./logs/logging.sh

remove_apps() {
  while IFS= read -r app; do
    case "$app" in
      apt:*)
        package="${app#apt:}"
        if dpkg -l | grep -i "$package" &>/dev/null; then
          sudo apt-get purge -y "$package" && log_success "Debian app removed: $package"
        else
          log_info "APT package not found: $package"
        fi
        ;;
        
      flatpak:*)
        package="${app#flatpak:}"
        if flatpak list | grep -i "$package" &>/dev/null; then
          sudo flatpak uninstall -y "$package" && log_success "Flatpak app removed: $package"
        else
          log_info "Flatpak package not found: $package"
        fi
        ;;
        
      snap:*)
        package="${app#snap:}"
        if snap list | grep -i "$package" &>/dev/null; then
          sudo snap remove "$package" && log_success "Snap app removed: $package"
        else
          log_info "Snap package not found: $package"
        fi
        ;;
        
      *)
        log_warning "Unrecognized format for: $app"
        ;;
    esac
  done < ./config/remove_apps.txt
}


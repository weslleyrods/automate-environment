#!/bin/bash

source "./logs/logging.sh"
source "./utils/check_os.sh"
source "./utils/update_os.sh"
source "./scripts/install_packages.sh"

install_apps() {
  system_update
  install_flatpak
  install_snap

while IFS= read -r app; do
  case "$app" in
    apt:*)
      app_name="${app#apt:}"
      IFS='|' read -r apt_pkg apt_opts <<< "$app_name"  
      
      log_info "Installing via APT: $apt_pkg"
      if [[ -n "$apt_opts" ]]; then
        sudo apt install $apt_opts "$apt_pkg" || log_warning "Fail to install $apt_pkg via APT."
      else
        sudo apt install "$apt_pkg" || log_warning "Fail to install $apt_pkg via APT."
      fi
      ;;
    snap:*)
      app_name="${app#snap:}"
      IFS='|' read -r snap_pkg snap_opts <<< "$app_name"  
      
      log_info "Installing via Snap: $snap_pkg"
      if [[ -n "$snap_opts" ]]; then
        sudo snap install "$snap_pkg" $snap_opts || log_warning "Fail to install $snap_pkg via Snap."
      else
        sudo snap install "$snap_pkg" || log_warning "Fail to install $snap_pkg via Snap."
      fi
      ;;
    flatpak:*)
      app_name="${app#flatpak:}"
      IFS='|' read -r flatpak_pkg flatpak_opts <<< "$app_name"  # Divide o nome do pacote e as opções
      
      log_info "Installing via Flatpak: $flatpak_pkg"
      if [[ -n "$flatpak_opts" ]]; then
        sudo flatpak install -y "$flatpak_pkg" $flatpak_opts || log_warning "Fail to install $flatpak_pkg via Flatpak."
      else
        sudo flatpak install -y "$flatpak_pkg" || log_warning "Fail to install $flatpak_pkg via Flatpak."
      fi
      ;;
    wget:*)
      url="${app#wget:}"
      filename=$(basename "$url")
      log_info "Trying to install $filename with wget..."

      if wget -q "$url" -O "$filename"; then
        case "$filename" in
          *.deb)
            log_info "Installing $filename..."
            sudo dpkg -i "$filename" || log_warning "Failed to install $filename."
            log_success "$filename installed successfully!"
            ;;
          *)
            log_warning "Unrecognized file format for $filename."
            ;;
        esac

        rm -f "$filename" && log_success "File $filename removed."
      else
        log_warning "Fail to download $filename."
      fi
      ;;
    *)
      log_warning "Unrecognized file format for: $app"
      ;;
  esac
done < ./config/install_apps.txt
}

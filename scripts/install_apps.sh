#!/bin/bash

source ./logs/logging.sh
source install_packages.sh
source ./utils/check_os.sh
source ./utils/update_os.sh

install_apps() {
  system_update
  while IFS= read -r app; do
    case "$app" in
      apt:*)
        log_info "Instaling via APT: ${app#apt:}"
        install_app "${app#apt:}" || log_warning "Fail to install ${app#apt:} via APT."
        ;;
      snap:*)
        log_info "Instaling via Snap: ${app#snap:}"
        install_snap "${app#snap:}" || log_warning "Fail to install ${app#snap:} via Snap."
        ;;
      flatpak:*)
        log_info "Instaling via Flatpak: ${app#flatpak:}"
        install_flatpak "${app#flatpak:}" || log_warning "Fail to install ${app#flatpak:} via Flatpak."
        ;;
      wget:*)
        url="${app#wget: }"
        filename=$(basename "$url")
        log_info "Trying to install $filename with wget..."

        # Tenta baixar o arquivo
        if wget -q "$url" -O "$filename"; then
          case "$filename" in
            *.deb)
              log_info "Instaling $filename..."
              sudo dpkg -i "$filename"
              sudo apt-get install -f -y
              log_success "$filename instaled successfully!"
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



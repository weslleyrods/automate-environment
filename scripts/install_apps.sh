#!/bin/bash

source ./logs/logging.sh

is_deb_system(){
  if command -v dpkg &> /dev/null; then
    return 0
  else
    return 1 
  fi
}

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

install_apps() {
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



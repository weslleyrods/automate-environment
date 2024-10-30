#!/bin/bash

function install_apps() {
  while IFS= read -r app; do
    if [[ "$app" == "apt:"* ]]; then
      sudo apt-get install -y "${app#apt:}"
    elif [[ "$app" == "flatpak:"* ]]; then
      flatpak install -y "${app#flatpak:}"
    elif [[ "$app" == "snap:"* ]]; then
      sudo snap install "${app#snap:}"
    else
      echo "Unknown package type: $app"
    fi
  done < ./configs/list_install_apps.txt
}

install_apps

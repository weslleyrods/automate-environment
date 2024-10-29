#!/bin/bash
set -e

is_deb_system() {
  if command -v dpkg &> /dev/null; then
    return 0
  else
    return 1 
  fi
}

system_update() {
    if is_deb_system(); then
        sudo apt-get update && sudo apt-get upgrade -y
    else
        if command -v pacman &> /dev/null; then
            sudo pacman -Syu --noconfirm
        elif command -v dnf &> /dev/null; then
            sudo dnf update -y
        fi
    fi
}

install_git() {
  if ! command -v git &> /dev/null; then
    if is_deb_system(); then
      sudo apt-get install -y git
    elif command -v pacman &> /dev/null; then
      sudo pacman -S --noconfirm git
    elif command -v dnf &> /dev/null; then
      sudo dnf install -y git
    fi
  fi
}

install_wget() {
  if ! command -v wget &> /dev/null; then
    if is_deb_system(); then
      sudo apt-get install -y wget
    elif command -v pacman &> /dev/null; then
      sudo pacman -S --noconfirm wget
    elif command -v dnf &> /dev/null; then
      sudo dnf install -y wget
    else
      echo "Gerenciador de pacotes não suportado. Instale o wget manualmente."
    fi
  fi
}

install_flatpak() {
    if ! command -v flatpak &> /dev/null; then
      if is_deb_system(); then
        sudo apt-get install -y flatpak
      else
        sudo pacman -S --noconfirm flatpak || sudo dnf install -y flatpak
      fi
      sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
}

install_snap() {
    if ! command -v snap &> /dev/null; then
        if is_deb_system(); then
            sudo apt-get install -y snapd
        else
            sudo pacman -S --noconfirm snapd || sudo dnf install -y snapd
        fi
    fi
}

install_gnome_software() {
  if ! command -v gnome-software &> /dev/null; then
      sudo apt-get install -y gnome-software
  fi
}

install_onlyoffice() {
    if command -v desktopeditors &> /dev/null; then
      return
    fi

    if is_deb_system(); then
      wget -q https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb -O onlyoffice.deb
      sudo dpkg -i onlyoffice.deb
      sudo apt-get install -f -y
      rm onlyoffice.deb
    else
      sudo flatpak install -y flathub org.onlyoffice.desktopeditors
    fi
}

install_postman() {
  if command -v postman &> /dev/null; then
    return
  fi

  if is_deb_system(); then
    wget -q https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
    sudo tar -xzf postman.tar.gz -C /opt
    sudo ln -s /opt/Postman/Postman /usr/bin/postman
    rm postman.tar.gz
  else
    sudo flatpak install -y flathub com.getpostman.Postman
  fi
}

install_vscode() {
  if command -v code &> /dev/null; then
    return
  fi

  if is_deb_system(); then
    wget -q https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb
    sudo dpkg -i vscode.deb
    sudo apt-get install -f -y
    rm vscode.deb
  else
    sudo flatpak install -y flathub com.visualstudio.code
  fi
}

install_discord() {
  if command -v discord &> /dev/null; then
    return
  fi

  if is_deb_system(); then
    wget -q https://discord.com/api/download?platform=linux&format=deb -O discord.deb
    sudo dpkg -i discord.deb
    sudo apt-get install -f -y
    rm discord.deb
  else
    sudo flatpak install -y flathub com.discordapp.Discord
  fi
}

install_mongo_compass() {
  if command -v mongodb-compass &> /dev/null; then
    return
  fi

  if is_deb_system(); then
    wget -q https://downloads.mongodb.com/compass/compass-latest-linux-x86_64.deb -O mongodb-compass.deb
    sudo dpkg -i mongodb-compass.deb
    sudo apt-get install -f -y
    rm mongodb-compass.deb
  else
    sudo flatpak install -y flathub org.mongodb.Compass
  fi
}

install_vivaldi() {
  if command -v vivaldi &> /dev/null; then
    return
  fi

  if is_deb_system(); then
    wget -q https://downloads.vivaldi.com/stable/vivaldi-stable_6.2.3105.36-1_amd64.deb -O vivaldi.deb
    sudo dpkg -i vivaldi.deb
    sudo apt-get install -f -y
    rm vivaldi.deb
  else
    sudo flatpak install -y flathub com.vivaldi.Vivaldi
  fi
}

install_google_chrome() {
  if command -v google-chrome &> /dev/null; then
    return
  fi

  if is_deb_system(); then
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome.deb
    sudo dpkg -i google-chrome.deb
    sudo apt-get install -f -y
    rm google-chrome.deb
  fi
}

install_warp_terminal() {
  if command -v warp &> /dev/null; then
    return
  fi
  sudo flatpak install -y flathub dev.warp.Warp
}

install_stremio() {
  if command -v stremio &> /dev/null; then
    return
  fi

  if is_deb_system(); then
    wget -q https://dl.strem.io/stremio/releases/stremio_0.22.1_amd64.deb -O stremio.deb
    sudo dpkg -i stremio.deb
    sudo apt-get install -f -y
    rm stremio.deb
  else
    sudo flatpak install -y flathub com.stremio.Stremio
  fi
}

install_docker() {
  if is_deb_system(); then
    # Docker Compose
    sudo apt-get update && sudo apt-get install -y docker-compose-plugin

    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
      sudo apt-get remove -y "$pkg" || true
    done

    # Docker Engine
    sudo apt-get update && sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo docker run hello-world
  else
    echo "Gerenciador de pacotes não suportado. Instale o Docker manualmente."
  fi
}


system_update
install_git
install_wget
install_flatpak
install_snap
install_warp_terminal

if is_deb_system(); then
  install_gnome_software
  install_docker

  install_postman
  install_vscode
  install_discord
  install_mongo_compass
  install_vivaldi
  install_google_chrome
  install_stremio
  install_onlyoffice
else
  install_postman
  install_vscode
  install_discord
  install_mongo_compass
  install_vivaldi
  echo "Google Chrome não está disponível via Flatpak."
  install_stremio
  install_onlyoffice
fi



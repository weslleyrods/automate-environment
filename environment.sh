#!/bin/bash
set -e

# Cores para logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sem cor

log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

is_deb_system(){
  if command -v dpkg &> /dev/null; then
    return 0
  else
    return 1 
  fi
}

system_update(){
  log_info "Atualizando o sistema..."
  if is_deb_system; then
    sudo apt-get update && sudo apt-get upgrade -y && log_success "Sistema atualizado com sucesso!"
  else
    if command -v pacman &> /dev/null; then
      sudo pacman -Syu --noconfirm && log_success "Sistema atualizado com sucesso!"
    elif command -v dnf &> /dev/null; then
      sudo dnf update -y && log_success "Sistema atualizado com sucesso!"
    else
      log_warning "Gerenciador de pacotes não suportado para atualização."
    fi
  fi
}

install_git(){
  log_info "Verificando instalação do Git..."
    if is_deb_system; then
      sudo apt-get install -y git && log_success "Git instalado com sucesso!"
    elif command -v pacman &> /dev/null; then
      sudo pacman -S --noconfirm git && log_success "Git instalado com sucesso!"
    elif command -v dnf &> /dev/null; then
      sudo dnf install -y git && log_success "Git instalado com sucesso!"
    else
      log_warning "Gerenciador de pacotes não suportado para instalação do Git."
    fi
  fi
}

install_wget(){
  log_info "Verificando instalação do Wget..."
  if is_deb_system; then
    sudo apt-get install -y wget && log_success "Wget instalado com sucesso!"
  elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm wget && log_success "Wget instalado com sucesso!"
  elif command -v dnf &> /dev/null; then
    sudo dnf install -y wget && log_success "Wget instalado com sucesso!"
  else
    log_warning "Gerenciador de pacotes não suportado para instalação do Wget."
  fi
}

install_flatpak(){
  log_info "Instalando Flatpak..."
  if is_deb_system; then
    sudo apt-get install -y flatpak && log_success "Flatpak instalado com sucesso!"
  else
    sudo pacman -S --noconfirm flatpak || sudo dnf install -y flatpak && log_success "Flatpak instalado com sucesso!"
  fi
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  fi
}

install_snap(){
  log_info "Verificando instalação do Snap..."
  if is_deb_system; then
    sudo apt-get install -y snapd && log_success "Snap instalado com sucesso!"
  else
    sudo pacman -S --noconfirm snapd || sudo dnf install -y snapd && log_success "Snap instalado com sucesso!"
  fi
}

install_gnome_software(){
  log_info "Instalando Gnome Software..."
  sudo apt-get install -y gnome-software && log_success "Gnome Software instalado com sucesso!"
  fi
}

install_onlyoffice(){
  log_info "Instalando OnlyOffice..."
  if is_deb_system; then
    sudo snap install onlyoffice-desktopeditors
    log_success "OnlyOffice instalado com sucesso!"
  else
    sudo flatpak install flathub org.onlyoffice.desktopeditors && log_success "OnlyOffice instalado com sucesso!"
  fi
}

install_postman(){
  log_info "Verificando instalação do Postman..."

  if flatpak list | grep -q "com.getpostman.Postman"; then
    log_info "Postman já está instalado via Flatpak."
    return
  fi

  log_info "Instalando Postman..."
  if is_deb_system; then
    sudo snap install postman
    log_success "Postman instalado com sucesso!"
  else
    sudo flatpak install -y flathub com.getpostman.Postman && log_success "Postman instalado com sucesso!"
  fi
}


install_vscode(){
  log_info "Instalando VSCode..."
  if is_deb_system; then
    wget -q https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb
    sudo dpkg -i vscode.deb
    sudo apt-get install -f -y
    rm vscode.deb && log_success "VSCode instalado com sucesso!"
  else
    sudo flatpak install -y flathub com.visualstudio.code && log_success "VSCode instalado com sucesso!"
  fi
}

install_discord() {
  log_info "Instalando Discord..."
  if is_deb_system; then
    wget -q "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
    sudo dpkg -i discord.deb
    sudo apt-get install -f -y
    rm discord.deb && log_success "Discord instalado com sucesso!"
  else
    sudo flatpak install -y flathub com.discordapp.Discord && log_success "Discord instalado com sucesso!"
  fi
}

install_mongo_compass(){
  log_info "Instalando MongoDB Compass..."
  if is_deb_system; then
    wget -q https://downloads.mongodb.com/compass/mongodb-compass_1.44.5_amd64.deb -O mongodb-compass.deb
    sudo dpkg -i mongodb-compass.deb
    sudo apt-get install -f -y
    rm mongodb-compass.deb && log_success "MongoDB Compass instalado com sucesso!"
  else
    sudo flatpak install -y flathub org.mongodb.Compass && log_success "MongoDB Compass instalado com sucesso!"
  fi
}

install_vivaldi(){
  log_info "Instalando Vivaldi..."
  if is_deb_system; then
    wget -q https://downloads.vivaldi.com/stable/vivaldi-stable_6.2.3105.36-1_amd64.deb -O vivaldi.deb
    sudo dpkg -i vivaldi.deb
    sudo apt-get install -f -y
    rm vivaldi.deb && log_success "Vivaldi instalado com sucesso!"
  else
    sudo flatpak install -y flathub com.vivaldi.Vivaldi && log_success "Vivaldi instalado com sucesso!"
  fi
}

install_google_chrome(){
  log_info "Instalando Google Chrome..."
  if is_deb_system; then
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
    sudo dpkg -i chrome.deb
    rm chrome.deb
    log_success "Google Chrome instalado com sucesso!"
  else
    log_warning "Instalação automática do Google Chrome não suportada fora de sistemas baseados em Debian."
  fi
}

install_warp_terminal(){
  log_info "Instalando Warp Terminal..."
  wget -q https://app.warp.dev/get_warp?package=deb -O warp.deb
  sudo dpkg -i warp.deb
  sudo apt-get install -f -y
  rm warp.deb && log_success "Warp Terminal instalado com sucesso!" && log_success "Warp Terminal instalado com sucesso!"
}

install_stremio(){
  log_info "Instalando Stremio..."
  if is_deb_system; then
    wget -q https://dl.strem.io/stremio/releases/stremio_0.22.1_amd64.deb -O stremio.deb
    sudo dpkg -i stremio.deb
    sudo apt-get install -f -y
    rm stremio.deb && log_success "Stremio instalado com sucesso!"
  else
    sudo flatpak install -y flathub com.stremio.Stremio && log_success "Stremio instalado com sucesso!"
  fi
}

install_docker(){
  log_info "Instalando Docker..."
  if is_deb_system; then
    # Docker Engine
    log_info "Instalando Docker Engine..."

    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo docker run hello-world && log_success "Docker instalado e testado com sucesso!"

    # Docker Compose
    log_info "Instalando Docker Compose..."
    sudo apt-get update
    sudo apt-get install docker-compose-plugin

    # Verifica se o grupo docker já existe
    if ! getent group docker > /dev/null; then
      sudo groupadd docker  # Cria o grupo docker se não existir
    fi

    # Adiciona o usuário ao grupo docker
    sudo usermod -aG docker $USER  # Adiciona o usuário atual ao grupo docker
  else
    log_warning "Gerenciador de pacotes não suportado. Instale o Docker manualmente."
  fi
}

system_update
install_git
install_wget
install_flatpak
install_snap
install_warp_terminal

if is_deb_system; then
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
  log_warning "Google Chrome não está disponível via Flatpak."
  install_stremio
  install_onlyoffice
fi
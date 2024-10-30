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

install_flatpak() {
  log_info "Instalando Flatpak..."

  if is_deb_system; then
    sudo apt-get install -y flatpak && log_success "Flatpak instalado com sucesso!"
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm flatpak && log_success "Flatpak instalado com sucesso!"
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y flatpak && log_success "Flatpak instalado com sucesso!"
  else
    log_error "Nenhum gerenciador de pacotes compatível encontrado!"
    return 1
  fi
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && log_success "Repositório Flathub adicionado!"
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
    wget -q https://downloads.vivaldi.com/stable/vivaldi-stable_7.0.3495.6-1_amd64.deb -O vivaldi.deb
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
  wget -q https://app.warp.dev/download?package=deb -O warp-terminal.deb

  if file warp-terminal.deb | grep -q 'Debian binary package'; then
    sudo dpkg -i warp-terminal.deb
    sudo apt-get install -f -y
    rm warp-terminal.deb
    log_success "Warp Terminal instalado com sucesso!"
  else
    log_error "O arquivo baixado não é um pacote Debian válido."
    rm warp-terminal.deb
  fi
}

install_stremio(){
  log_info "Instalando Stremio..."
  sudo flatpak install -y flathub com.stremio.Stremio && log_success "Stremio instalado com sucesso!"
}

install_vlc(){
  log_info "Instalando VLC..."
  if is_deb_system; then
    sudo apt-get install -y vlc && log_success "VLC instalado com sucesso!"
  else
    sudo flatpak install -y flathub org.videolan.VLC && log_success "VLC instalado com sucesso!"
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

remove_apps() {
  log_info "Removendo LibreOffice..."
  sudo apt remove --purge -y libreoffice* || log_warning "Erro ao remover LibreOffice"
  if flatpak list | grep -q org.libreoffice.LibreOffice; then
    sudo flatpak uninstall --delete-data -y org.libreoffice.LibreOffice || log_warning "Erro ao remover org.libreoffice.LibreOffice"
  fi
  sudo snap remove --purge libreoffice || log_warning "Erro ao remover LibreOffice do Snap"

  log_info "Removendo Firefox..."
  sudo apt remove --purge -y firefox || log_warning "Erro ao remover Firefox"
  if flatpak list | grep -q org.mozilla.firefox; then
    sudo flatpak uninstall --delete-data -y org.mozilla.firefox || log_warning "Erro ao remover org.mozilla.firefox"
  fi
  sudo snap remove --purge firefox || log_warning "Erro ao remover Firefox do Snap"

  log_info "Removendo Thunderbird..."
  sudo apt remove --purge -y thunderbird || log_warning "Erro ao remover Thunderbird"
  if flatpak list | grep -q org.mozilla.Thunderbird; then
    sudo flatpak uninstall --delete-data -y org.mozilla.Thunderbird || log_warning "Erro ao remover org.mozilla.Thunderbird"
  fi
  sudo snap remove --purge thunderbird || log_warning "Erro ao remover Thunderbird do Snap"

  log_info "Removendo programas de mídia (Cheese, Rhythmbox, Shotwell)..."
  sudo apt remove --purge -y cheese rhythmbox shotwell || log_warning "Erro ao remover programas de mídia"
  if flatpak list | grep -q org.gnome.Cheese; then
    sudo flatpak uninstall --delete-data -y org.gnome.Cheese || log_warning "Erro ao remover org.gnome.Cheese"
  fi
  if flatpak list | grep -q org.gnome.Rhythmbox3; then
    sudo flatpak uninstall --delete-data -y org.gnome.Rhythmbox3 || log_warning "Erro ao remover org.gnome.Rhythmbox3"
  fi
  if flatpak list | grep -q org.gnome.Shotwell; then
    sudo flatpak uninstall --delete-data -y org.gnome.Shotwell || log_warning "Erro ao remover org.gnome.Shotwell"
  fi
  sudo snap remove --purge cheese rhythmbox shotwell || log_warning "Erro ao remover programas de mídia do Snap"

  log_info "Removendo jogos padrão do GNOME..."
  sudo apt remove --purge -y gnome-sudoku gnome-mahjongg gnome-mines aisleriot || log_warning "Erro ao remover jogos padrão do GNOME"
  if flatpak list | grep -q org.gnome.Sudoku; then
    sudo flatpak uninstall --delete-data -y org.gnome.Sudoku || log_warning "Erro ao remover org.gnome.Sudoku"
  fi
  if flatpak list | grep -q org.gnome.Mahjongg; then
    sudo flatpak uninstall --delete-data -y org.gnome.Mahjongg || log_warning "Erro ao remover org.gnome.Mahjongg"
  fi
  if flatpak list | grep -q org.gnome.Mines; then
    sudo flatpak uninstall --delete-data -y org.gnome.Mines || log_warning "Erro ao remover org.gnome.Mines"
  fi
  if flatpak list | grep -q org.gnome.Aisleriot; then
    sudo flatpak uninstall --delete-data -y org.gnome.Aisleriot || log_warning "Erro ao remover org.gnome.Aisleriot"
  fi
  sudo snap remove --purge gnome-sudoku gnome-mahjongg gnome-mines aisleriot || log_warning "Erro ao remover jogos do Snap"

  log_info "Removendo aplicativos adicionais (Brasero, Remmina, GIMP)..."
  sudo apt remove --purge -y brasero remmina gimp || log_warning "Erro ao remover Brasero, Remmina ou GIMP"
  if flatpak list | grep -q org.gnome.Brasero; then
    sudo flatpak uninstall --delete-data -y org.gnome.Brasero || log_warning "Erro ao remover org.gnome.Brasero"
  fi
  if flatpak list | grep -q org.remmina.Remmina; then
    sudo flatpak uninstall --delete-data -y org.remmina.Remmina || log_warning "Erro ao remover org.remmina.Remmina"
  fi
  if flatpak list | grep -q org.gimp.GIMP; then
    sudo flatpak uninstall --delete-data -y org.gimp.GIMP || log_warning "Erro ao remover org.gimp.GIMP"
  fi
  sudo snap remove --purge brasero remmina gimp || log_warning "Erro ao remover Brasero, Remmina ou GIMP do Snap"

  sudo apt autoremove -y
  sudo apt autoclean -y

  log_success "Programas desnecessários removidos com sucesso!"
}



system_update
install_git
install_wget
install_flatpak
install_snap
install_vlc
remove_apps

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


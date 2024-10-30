#!/bin/bash

source ./logs/logging.sh

install_docker_for_deb(){
  log_info "Installing Docker..."
  log_info "Installing Docker Engine..."

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
  sudo docker run hello-world && log_success "Docker instaled e tested with success!"

  # Docker Compose
  log_info "Installing Docker Compose..."
  sudo apt-get update
  sudo apt-get install docker-compose-plugin

  if ! getent group docker > /dev/null; then
    sudo groupadd docker  
  fi

  sudo usermod -aG docker $USER  
}

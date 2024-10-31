#!/bin/bash

source "./scripts/install_docker.sh"
source "./scripts/remove_apps.sh"
source "./scripts/install_apps.sh"

remove_apps
install_apps
install_docker
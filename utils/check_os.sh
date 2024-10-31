#!/bin/bash

is_deb_system(){
  if command -v dpkg &> /dev/null; then
    return 0
  else
    return 1 
  fi
}
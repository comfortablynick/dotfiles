#!/usr/bin/env bash
# Update all apt packages

# if not root, run as root
if (( $EUID != 0 )); then
    sudo "$XDG_CONFIG_HOME/bash/functions/apt_update.sh"
    exit
fi

apt update
apt -y dist-upgrade
apt -y autoremove
apt clean
apt purge -y $(dpkg -l | awk '/^rc/ { print $2 }')

#!/bin/bash
cd ~
sudo apt dist-upgrade -y && sudo apt update -y && sudo apt upgrade -y &&
sudo apt install vim -y
sudo apt install htop -y
sudo apt install git -y &&
sudo apt install zsh -y &&
sudo apt install nmap -y &&
sudo apt install netcat-openbsd -y &&
sudo apt install gobuster -y &&
sudo apt install nikto -y &&
sudo apt install metasploit-framework -y &&
sudo apt install wpscan -y &&
sudo apt install telnet -y &&
sudo apt install sqlmap -y &&
sudo apt install recon-ng -y &&
wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb && dpkg -i lsd*.deb && rm lsd*.deb &&
sudo chsh -s /bin/zsh && source .zshrc &&
sudo apt update -y && sudo apt upgrade -y

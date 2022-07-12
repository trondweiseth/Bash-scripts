#!/bin/bash
cd $HOME && mkdir Tools && cd Tools &&
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
sudo apt install openvpn -y &&
sudo apt install bruteforce-salted-openssl -y &&
sudo apt install cargo -y &&
cargo install --git https://github.com/mufeedvh/moonwalk.git
python3 -m pip install virtualenv &&
git clone https://github.com/SecureAuthCorp/impacket.git && cd impacket && python3 -m install . && cd
wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb && dpkg -i lsd*.deb && rm lsd*.deb &&
git clone https://github.com/SecureAuthCorp/impacket.git &&
git clone https://github.com/fox-it/BloodHound.py.git &&
sudo gem install winrm winrm-fs stringio logger fileutils
git clone https://github.com/Hackplayers/evil-winrm.git &&
git clone https://github.com/SpiderLabs/Responder.git &&
sudo chsh -s /bin/zsh && source .zshrc &&
sudo apt update -y && sudo apt upgrade -y
echo "alias ls='lsd'" >> ~/.bashrc
echo "alias ll='lsd -al'" >> ~/.bashrc
echo "alias lt='ls --tree'" >> ~/.bashrc
source ~/.bashrc

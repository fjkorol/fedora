#!/bin/bash 
 
sudo dnf -y install @development-tools\n
sudo dnf -y install kernel-headers kernel-devel dkms elfutils-libelf-devel qt5-qtx11extras\n
sudo rpm --import https://www.virtualbox.org/download/oracle_vbox_2016.asc\n
sudo wget -P /etc/yum.repos.d/ https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo\n
sudo dnf search VirtualBox-7.
sudo dnf install VirtualBox-7.2
sudo usermod -aG vboxusers $USER\n
wget https://download.virtualbox.org/virtualbox/7.2.0/Oracle_VirtualBox_Extension_Pack-7.2.0.vbox-extpack\n
sudo VBoxManage extpack install Oracle_VirtualBox_Extension_Pack-7.2.0.vbox-extpack\n
sudo VBoxManage list extpacks\n

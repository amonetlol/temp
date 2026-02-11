#!/usr/bin/env bash
set -euo pipefail


# Variables
#----------------------------
# Color variables
GREEN="\e[32m"
WHITE="\e[0m"
YELLOW="\e[33m"
BLUE="\e[34m"

root_dir=$(pwd)

# time variable
start=$(date +%s)

#----------------------------

# Welcome message
echo -e "
                    ${GREEN}\e[1mWELCOME!${GREEN} 
    Now we will customize Arch-based Terminal
             Created by \e[1;4mPhunt_Vieg_
${WHITE}"

cd ~

# Updating the system
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[1/10]${GREEN} ==> Updating system packages\n---------------------------------------------------------------------\n${WHITE}"
sudo pacman -Syu --noconfirm


# Setting locale 
# echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[2/10]${GREEN} ==> Setting locale \n---------------------------------------------------------------------\n${WHITE}"
# sudo sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
# sudo locale-gen
# sudo localectl set-locale LANG=en_US.UTF-8


# Download some terminal tool
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[3/10]${GREEN} ==> Download some terminal tool\n---------------------------------------------------------------------\n${WHITE}"
sudo pacman -S --noconfirm --needed base-devel git
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si --noconfirm
cd $root_dir
rm -rf root_dir/yay


pacman_packages=(
    # System monitoring and fun terminal visuals
    btop fastfetch starship

    # Essential utilities
    make curl wget unzip ripgrep fd eza bat zoxide neovim stow lazygit duf wl-clipboard

    # Programming languages
    python3 python-pip nodejs npm
)
aur_packages=(
  ##
)


# Download pacman packages
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[4/10]${GREEN} ==> Download pacman packages\n---------------------------------------------------------------------\n${WHITE}"
sudo pacman -S --noconfirm "${pacman_packages[@]}"


# Download yay packages
# echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[5/10]${GREEN} ==> Download yay packages\n---------------------------------------------------------------------\n${WHITE}"
# yay -S --noconfirm "${aur_packages[@]}"


# Allow pip3 install by removing EXTERNALLY-MANAGED file
# echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[6/10]${GREEN} ==> Allow pip3 install by removing EXTERNALLY-MANAGED file\n---------------------------------------------------------------------\n${WHITE}"
# sudo rm -rf $(python3 -c "import sys; print(f'/usr/lib/python{sys.version_info.major}.{sys.version_info.minor}/EXTERNALLY-MANAGED')")

# Launch auto-setup script and dl all the dotfiles
echo -e "${PINK}\n---------------------------------------------------------------------\n${YELLOW}[2/11]${PINK} ==> Setup terminal\n---------------------------------------------------------------------\n${WHITE}"
sleep 0.5
#bash -c "$(curl -fSL https://raw.githubusercontent.com/ViegPhunt/auto-setup-LT/main/arch.sh)"
chmod +x $root_dir/install_archpkg.sh
$root_dir/install_archpkg.sh

# enable bluetooth & networkmanager
echo -e "${BLUE}\n---------------------------------------------------------------------\n${YELLOW}[6/11]${BLUE} ==> Enable bluetooth & networkmanager\n---------------------------------------------------------------------\n${WHITE}"
sleep 0.5
#sudo systemctl enable --now bluetooth
sudo systemctl enable --now NetworkManager

# Check display manager
echo -e "${BLUE}\n---------------------------------------------------------------------\n${YELLOW}[11/11]${BLUE} ==> Check display manager\n---------------------------------------------------------------------\n${WHITE}"
if [[ ! -e /etc/systemd/system/display-manager.service ]]; then
    sudo systemctl enable sddm
    echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee -a /etc/sddm.conf
    sudo sed -i 's|astronaut.conf|purple_leaves.conf|' /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
    echo -e "\n${PINK}SDDM has been enabled."
fi

# Download file config"
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[8/10]${GREEN} ==> Download file config\n---------------------------------------------------------------------\n${WHITE}"
git clone --depth=1 https://github.com/ViegPhunt/Dotfiles.git ~/dotfiles
sudo chmod +x ~/dotfiles/.config/viegphunt/*

# Apply fonts
echo -e "${BLUE}\n---------------------------------------------------------------------\n${YELLOW}[8/11]${BLUE} ==> Apply fonts\n---------------------------------------------------------------------\n${WHITE}"
fc-cache -fv

# Set cursor
echo -e "${BLUE}\n---------------------------------------------------------------------\n${YELLOW}[9/11]${BLUE} ==> Set cursor\n---------------------------------------------------------------------\n${WHITE}"
~/dotfiles/.config/viegphunt/setcursor.sh

# Stow
echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[9/10]${GREEN} ==> Stow\n---------------------------------------------------------------------\n${WHITE}"
cd ~/dotfiles
./.config/viegphunt/backup_config.sh
stow -t ~ .
cd ~

# Change shell
# echo -e "${GREEN}\n---------------------------------------------------------------------\n${YELLOW}[10/10]${GREEN} ==> Change shell\n---------------------------------------------------------------------\n${WHITE}"
# ZSH_PATH="$(which zsh)"
# grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
# chsh -s "$ZSH_PATH"

# Wait a little just for the last message
sleep 0.7
clear

# Calculate how long the script took
end=$(date +%s)
duration=$((end - start))

hours=$((duration / 3600))
minutes=$(((duration % 3600) / 60))
seconds=$((duration % 60))

printf -v minutes "%02d" "$minutes"
printf -v seconds "%02d" "$seconds"

echo -e "\n


echo -e "\n ${GREEN}
 **************************************************
 *                    \e[1;4mDone\e[0m${GREEN}!!!                     *
 *       Please relogin to apply new config.      *
 **************************************************
 
"

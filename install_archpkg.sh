#!/usr/bin/env bash

pacman_packages=(
    # Hyprland & Wayland Environment
    hyprland hyprlock swww grim slurp swaync waybar rofi rofi-emoji yad hyprshot xdg-desktop-portal-hyprland xdg-desktop-portal xdg-desktop-portal-gtk

    # System
    #brightnessctl 
    network-manager-applet bluez bluez-utils blueman pipewire wireplumber pavucontrol
    
    # System Utilities and Media
    foot thunar thunar thunar-archive-plugin gvfs loupe xarchive unrar 7zip
    
    # Qt & Display Manager Support
    sddm qt5ct qt6ct qt5-wayland qt6-wayland

    # Misc
    ttf-jetbrains-mono-nerd noto-fonts nwg-look adw-gtk-theme cliphist
)

aur_packages=(
    # Hyprland & Wayland Environment
    wlogout

    # System Utilities and Media

    # Communication
    zen-browser-bin

    # Code Editors and IDEs
    visual-studio-code-bin  

    # Misc
    ttf-segoe-ui-variable sddm-astronaut-theme apple_cursor whitesur-icon-theme tint
)

sudo pacman -S --noconfirm "${pacman_packages[@]}"
yay -S --noconfirm "${aur_packages[@]}"

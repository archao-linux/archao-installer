# VARIABLES #
# Define PACKAGES
PACKAGES := `grep -v '^#' packages/pacman.txt | awk NF | tr '\n' ' ' | sed 's/ $//'`
# Define AUR_PACKAGES
AUR_PACKAGES := `grep -v '^#' packages/aur.txt | awk NF | tr '\n' ' ' | sed 's/ $//'`

# RECIPES #
## SYSTEM PACKAGES ##
# Update System
update-system:
    @echo "updating system..."
    sudo pacman -Syyu --noconfirm

# Install Packages
install-packages:
    @echo "installing packages..."
    sudo pacman -S --noconfirm {{PACKAGES}}
    @echo "check & conditionally install yay..."
    yay --version || (git clone https://aur.archlinux.org/yay.git && rm -rf yay/.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay)
    @echo "installing AUR packages..."
    yay -S --noconfirm {{AUR_PACKAGES}}

## SYSTEMD BOOT ##
# Maximize Resolution
systemd-max:
    @echo "maximizing resolution..."
    sudo sed -i 's/^#\s*\(console-mode\) keep/\1 max/' /boot/loader/loader.conf

# Silent Boot
systemd-silent:
    @echo "silencing boot..."
    sudo sed -i '/^options/s/$/ quiet splash/' /boot/loader/entries/*_linux-zen.conf

## PLYMOUTH ##
# Add Plymouth Hook
hook-plymouth:
    @echo "adding plymouth hook..."
    sudo sed -i 's/HOOKS=(base udev/HOOKS=(base udev plymouth/' /etc/mkinitcpio.conf

# Add Plymouth Theme
theme-plymouth:
    @echo "adding plymouth theme..."
    sudo unzip files/plymouth/arch-mac-style.zip -d /usr/share/plymouth/themes/
    sudo plymouth-set-default-theme arch-mac-style
    sudo mkinitcpio -P

## SSDM ##
# Add SSDM Theme
theme-sddm:
    @echo "configuring sddm theme..."
    git clone -b main https://github.com/archao-linux/archao-sddm.git && rm -rf archao-sddm/.git
    sudo cp -r archao-sddm /usr/share/sddm/themes/
    echo -e "[Theme]\nCurrent=archao-sddm" | sudo tee -a /etc/sddm.conf
    sudo systemctl enable sddm.service

## DOTFILES ##
# Configure Hyprland
config-hyprland:
    @echo "configuring hyprland..."
    git clone -b chao https://github.com/archao-linux/archao-hyprland.git && rm -rf archao-hyprland/.git
    cp -r archao-hyprland/configs/* ~/.config
    cp -r archao-hyprland/assets/* ~/.hypr-assets/ && sudo cp -r archao-hyprland/assets/wlogout /usr/local/share/wlogout/
    sudo tar -xvf archao-hyprland/assets/themes/Catppuccin-Mocha.tar.xz -C /usr/share/themes/
    sudo tar -xvf archao-hyprland/assets/icons/Tela-circle-dracula.tar.xz -C /usr/share/icons/

## MISC ##
# Install OMB
install-omb:
    @echo "installing omb..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# & Configure OMB
config-omb:
    @echo "configuring omb..."
    sed -i 's/OSH_THEME="[^"]*"/OSH_THEME="robbyrussell"/' ~/.bashrc

# Configure Fastfetch
config-fastfetch:
    @echo "configuring fastfetch..."
    fastfetch --gen-config
    cp config/fastfetch.jsonc ~/.config/fastfetch/config.jsonc

# Enable Audio
enable-audio:
    @echo "enabling audio..."
    # Enable pipewire
    systemctl --user enable pipewire.service
    systemctl --user start pipewire.service

    # Enable pipewire-pulse
    systemctl --user enable pipewire-pulse.service
    systemctl --user start pipewire-pulse.service

    # Enable wireplumber
    systemctl --user enable wireplumber.service
    systemctl --user start wireplumber.service

# Enable Bluetooth
enable-bluetooth:
    @echo "enabling bluetooth..."
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service

# Enable Avahi
enable-avahi:
    @echo "enabling avahi..."
    sudo systemctl enable avahi-daemon.service
    sudo systemctl start avahi-daemon.service

# Select Themes
select-themes:
    @echo "selecting themes..."
    sudo -E nwg-look
    sudo -E kvantummanager
    sudo -E qt5ct
    sudo -E qt6ct

# VARIABLES #
# Define PACKAGES
PACKAGES := `grep -v '^#' packages/pacman.txt | awk NF | tr '\n' ' ' | sed 's/ $//'`
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
    yay --version || (git clone https://aur.archlinux.org/yay.git && rm -r yay/.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay)
    @echo "installing AUR packages..."
    yay -S --noconfirm {{AUR_PACKAGES}}

## SYSTEMD BOOT ##
# Maximize Resolution
systemd-max:
    @echo "maximizing resolution..."
    echo -e "console-mode max\n" | sudo tee -a /boot/loader/loader.conf

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
    sudo unzip files/plymouth/arc-mac-style.zip -d /usr/share/plymouth/themes/
    sudo plymouth-set-default-theme arc-mac-style
    sudo mkinitcpio -P

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
    systemctl --user enable bluetooth.service
    systemctl --user start bluetooth.service
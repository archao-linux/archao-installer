# Installer
## Dependencies

```bash
sudo pacman -S just git
```

## Recipes

| Name | Description |
|------|-------------|
| `update-system` | Updates the entire system using `pacman -Syyu --noconfirm` |
| `install-packages` | Installs packages from `packages/pacman.txt`, sets up yay AUR helper, and installs AUR packages from `packages/aur.txt` |
| `systemd-max` | Maximizes console resolution by setting `console-mode max` in systemd-boot loader configuration |
| `systemd-silent` | Enables silent boot by adding `quiet splash` parameters to systemd-boot entries |
| `hook-plymouth` | Adds Plymouth hook to `/etc/mkinitcpio.conf` for boot splash screen support |
| `theme-plymouth` | Installs and sets the arch-mac-style Plymouth theme from `files/plymouth/` |
| `theme-sddm` | Clones and installs the Archao SDDM theme, configures it as default, and enables SDDM service |
| `config-hyprland` | Clones Archao Hyprland configuration, copies configs to `~/.config`, installs themes, icons, and assets |
| `install-omb` | Downloads and installs Oh My Bash shell framework |
| `config-omb` | Configures Oh My Bash to use the robbyrussell theme |
| `config-fastfetch` | Generates fastfetch configuration and applies custom config from `config/fastfetch.jsonc` |
| `enable-audio` | Enables and starts PipeWire audio services (pipewire, pipewire-pulse, wireplumber) |
| `enable-bluetooth` | Enables and starts the Bluetooth service |
| `enable-avahi` | Enables and starts the Avahi daemon for network service discovery |
| `enable-iwd` | Enables and starts the IWD (iNet Wireless Daemon) service for wireless networking |
| `select-themes` | Opens theme selection tools (nwg-look, kvantummanager, qt5ct, qt6ct) for GUI customization |

## Usage

Run any recipe using:
```bash
just <recipe-name>
```

Example:
```bash
just update-system
just install-packages
just config-hyprland
```
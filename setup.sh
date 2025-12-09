#!/bin/bash


is_root=true


# List of packages to check/install
packages=(
    "i3lock-fancy"
    "copyq"
    "flameshot"
    "polybar"
    "rofi"
    "feh"
    "xinput"
    "pavucontrol"
    "tmux"
    "qterminal"
    "python3-psutil"
    "network-manager-gnome"
    "network-manager"
    "blueman"

)
# Require sudo upfront

for pkg in "${packages[@]}"; do
    echo "Checking: $pkg"

    # Check if installed (match package name in status column)
    if dpkg -l | grep -E "^ii  $pkg[[:space:]]" > /dev/null; then
        echo "✔ $pkg is already installed."
    else
        echo "➜ Installing $pkg..."
        sudo apt install -y "$pkg"

        # Check success
        if dpkg -l | grep -E "^ii  $pkg[[:space:]]" > /dev/null; then
            echo "✔ Successfully installed $pkg."
        else
            echo "❌ Failed to install $pkg."
        fi
    fi

    echo "------------------------------------"
done

echo "All checks completed."


######### Install The Softwares Needed ##############

find ~/.config/i3 -type f -name "*.sh" -exec chmod +x {} \;
find ~/.config/i3 -type f -name "*.py" -exec chmod +x {} \;
chmod -R +x ~/.config/i3/config
######### Make pre-boot.sh Executable ##################


read -p "Do you want to install theme? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme /tmp/WhiteSur-gtk-theme
    git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme /tmp/WhiteSur-gtk-icon
    echo "✔ Themes cloned to /tmp"
    sudo /tmp/WhiteSur-gtk-theme/install.sh
    sudo  /tmp/WhiteSur-gtk-icon/install.sh
    echo "✔ Themes installed successfully."
    
fi
######### Install Theme ##################

read -p "Do you want to configure-network? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo cp /etc/network/interfaces /etc/network/interfaces.bak
    sudo sed -i 's/^iface wlp0s20f3.*/#&/' /etc/network/interfaces && sudo sed -i 's/wpa-ssid.*/#&/' /etc/network/interfaces && sudo sed -i 's/wpa-psk.*/#&/' /etc/network/interfaces  && sudo sed -i 's/allow-hotplug.*/#&/' /etc/network/interfaces 
    sudo systemctl enable --now NetworkManager
    sudo nmcli radio wifi on
fi
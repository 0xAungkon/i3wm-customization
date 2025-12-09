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
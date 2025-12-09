#!/bin/bash


is_root=true

if [[ $EUID -ne 0 ]]; then
   is_root=false
fi

if [ "$is_root" = true ]; then

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

else
    echo "User is Not Root. Skipping Package Installation."
fi
######### 1. Install The Softwares Needed ##############

ln -s /home/$USER/.config/i3/configs/tmux.conf /home/$USER/.tmux.conf
######### 2. Link The Tmux Config File ##################

chmod -R +x /home/$USER/.config/i3/*.sh
chmod -R +x /home/$USER/.config/i3/*.py
chmod -R +x /home/$USER/.config/i3/config
######### 3. Make pre-boot.sh Executable ##################
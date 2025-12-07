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


# if [ "$is_root" = false ]; then
    # fname="$HOME/Pictures/$(date +%Y%m%d%H%M%S).jpg"
    # wget -O "$fname" "https://picsum.photos/1920/1080"
    # cp -f "$fname" /tmp/wallpaper.jpg
# fi
############# 2. Random Image From picsum.photos ####################


# if [ "$is_root" = false ]; then
#     fname="$HOME/Pictures/$(date +%Y%m%d%H%M%S).jpg"
#     wget -O "$fname" "https://bing.biturl.top/?resolution=1920&format=image&index=random&mkt=en-US"
#     cp -f "$fname" /tmp/wallpaper.jpg
# fi
############# 3. Random Image From bing ####################


id=`xinput list | grep -i "Touchpad" | cut -d'=' -f2 | cut -d'[' -f1`
if [ -z "$id" ]; then
    echo "No touchpad found."
else
    tap_to_click_id=`xinput list-props $id | \
                      grep -i "Tapping Enabled (" \
                      | cut -d'(' -f2 | cut -d')' -f1`

    # Set the property to true
    xinput --set-prop $id $tap_to_click_id 1
    ############# 4. Touchpad Set to Tap To Click ####################


    natural_scrolling_id=`xinput list-props $id | \
                        grep -i "Natural Scrolling Enabled (" \
                        | cut -d'(' -f2 | cut -d')' -f1`

    # Set the property to true
    xinput --set-prop $id $natural_scrolling_id 1
    ############# 5. Touchpad Set to Natural Click ####################
fi


killall -q polybar
polybar --config=$HOME/.config/i3/polybar.ini &



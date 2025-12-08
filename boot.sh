#!/bin/bash

# fname="$HOME/Pictures/$(date +%Y%m%d%H%M%S).jpg"
# wget -O "$fname" "https://picsum.photos/1920/1080"
# cp -f "$fname" /tmp/wallpaper.jpg
############# 1. Random Image From picsum.photos ####################



fname="$HOME/Pictures/$(date +%Y%m%d%H%M%S).jpg"
wget -O "$fname" "https://bing.biturl.top/?resolution=1920&format=image&index=random&mkt=en-US"
cp -f "$fname" "$HOME/Pictures/wallpaper.jpg"
############ 1. Random Image From bing ####################


id=`xinput list | grep -i "Touchpad" | cut -d'=' -f2 | cut -d'[' -f1`
if [ -z "$id" ]; then
    echo "No touchpad found."
else
    tap_to_click_id=`xinput list-props $id | \
                      grep -i "Tapping Enabled (" \
                      | cut -d'(' -f2 | cut -d')' -f1`

    # Set the property to true
    xinput --set-prop $id $tap_to_click_id 1
    ############# 2. Touchpad Set to Tap To Click ####################


    natural_scrolling_id=`xinput list-props $id | \
                        grep -i "Natural Scrolling Enabled (" \
                        | cut -d'(' -f2 | cut -d')' -f1`

    # Set the property to true
    xinput --set-prop $id $natural_scrolling_id 1
    ############# 2. Touchpad Set to Natural Click ####################
fi


killall -q polybar
polybar --config=$HOME/.config/i3/polybar.ini 
############# 3. Initiate Polybar ####################
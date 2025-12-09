#!/usr/bin/env python3

import subprocess
import pickle
import os 
########### Import Libraries ###########

RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
CYAN = "\033[96m"
RESET = "\033[0m"
########### Set The Color Codes ###########

# Load data if it exists
file_path = os.path.expanduser("~/.config/i3/data.pkl")

presist_data={}
if os.path.exists(file_path):
    with open(file_path, "rb") as f:
        presist_data = pickle.load(f)

# Example: update data
# presist_data["counter"] = presist_data.get("counter", 0) + 1
# print("Counter:", presist_data["counter"])

########### Load the Presist Data ###########



def get_active_monitors():
    result = subprocess.run(['xrandr', '--verbose'], capture_output=True, text=True)
    monitors = []
    current = None

    for line in result.stdout.split('\n'):
        if ' connected' in line:
            current = line.split()[0]
        if current and 'Brightness:' in line:
            brightness = float(line.split()[-1])
            monitors.append({'name': current, 'brightness': int(brightness * 100)})
            current = None

    return monitors

active_monitors = get_active_monitors()

def show_monitor():
    for monitor in active_monitors:
        message=''

        if not 'focused_monitor' in presist_data:
            presist_data['focused_monitor']=monitor
        
        focused_monitor=monitor

        if focused_monitor['name']==monitor['name']:
            message=f"{monitor['name']}: {monitor['brightness']}%"

        print(message)

def next_value(lst, current):
    if not lst:
        return None
    if len(lst) == 1:
        return lst[0]
    try:
        index = lst.index(current)
        return lst[(index + 1) % len(lst)]
    except ValueError:
        return None
    
def change_monitor():
    focused_monitor=presist_data['focused_monitor']
    next_monitor=next_value(active_monitors,focused_monitor)
    presist_data['focused_monitor']=next_monitor


def brightness_up():
    focused_monitor = presist_data['focused_monitor']['name']
    # Get current brightness
    result = subprocess.run(['xrandr', '--verbose'], capture_output=True, text=True)
    current_brightness = 0
    for line in result.stdout.split('\n'):
        if focused_monitor in line:
            current_monitor = focused_monitor
        if 'Brightness:' in line and current_monitor == focused_monitor:
            current_brightness = float(line.split()[-1])
            break

    # Increase by 5%, round up to nearest multiple of 5
    new_brightness = int(current_brightness * 100)
    new_brightness = ((new_brightness + 4) // 5) * 5 + 5
    if new_brightness > 100:
        new_brightness = 100

    # Apply new brightness
    subprocess.run(['xrandr', '--output', focused_monitor, '--brightness', str(new_brightness / 100)])

def brightness_down():
    focused_monitor = presist_data['focused_monitor']['name']
    # Get current brightness
    result = subprocess.run(['xrandr', '--verbose'], capture_output=True, text=True)
    current_brightness = 0
    for line in result.stdout.split('\n'):
        if focused_monitor in line:
            current_monitor = focused_monitor
        if 'Brightness:' in line and current_monitor == focused_monitor:
            current_brightness = float(line.split()[-1])
            break

    # Decrease by 5%, round down to nearest multiple of 5
    new_brightness = int(current_brightness * 100)
    new_brightness = ((new_brightness) // 5) * 5 - 5
    if new_brightness < 0:
        new_brightness = 0

    # Apply new brightness
    subprocess.run(['xrandr', '--output', focused_monitor, '--brightness', str(new_brightness / 100)])


########### CLI Commands ###########

import sys

if len(sys.argv) < 2:
    print("No action provided")
    sys.exit(1)

action = sys.argv[1]

if action == '--show':
    show_monitor()

elif action == '--change-monitor':
    change_monitor()
    

elif action == '--brightness-up':
    brightness_up()
    

elif action == '--brightness-down':
    brightness_down()
    
else:
    print("Invalid action")
    sys.exit(1)


########### Save to Presist Data ###########

with open(file_path, "wb") as f:
    pickle.dump(presist_data, f)
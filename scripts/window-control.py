#!/usr/bin/env python3

import subprocess
import sys

# Get current workspace
current_workspace = subprocess.check_output(
    "wmctrl -d | grep '*' | awk '{print $1}'", shell=True, text=True
).strip()

# Get all windows
output = subprocess.check_output("wmctrl -l", shell=True, text=True).strip().split("\n")

windows = {}
for line in output:
    parts = line.split(None, 3)
    if len(parts) == 4:
        win_id, workspace, host, title = parts
        windows[win_id] = {
            "workspace": int(workspace),
            "host": host,
            "title": title
        }

# Filter windows in current workspace
current_workspace_windows = [
    win_id for win_id, info in windows.items() if info["workspace"] == int(current_workspace)
]

# Get window number from command line
if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} <window_number>")
    sys.exit(1)

try:
    win_num = int(sys.argv[1])
    if win_num == 9:
        win_index = len(current_workspace_windows) - 1  # last window
    else:
        win_index = win_num - 1  # Convert 1-based to 0-based index

    if win_index < 0 or win_index >= len(current_workspace_windows):
        raise IndexError
except (ValueError, IndexError):
    print(f"Invalid window number. Must be between 1 and {len(current_workspace_windows)}")
    sys.exit(1)

# Focus the selected window
win_id_to_focus = current_workspace_windows[win_index]
subprocess.run(f"wmctrl -i -a {win_id_to_focus}", shell=True)

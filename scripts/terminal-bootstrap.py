#!/usr/bin/env python3

########### Library Imports ###########
import subprocess
from datetime import datetime
import subprocess
from datetime import datetime
import psutil
import socket
import shutil
import getpass
import urllib.request

########### Color Codes ###########
RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
CYAN = "\033[96m"
RESET = "\033[0m"




# --- System Information ---
load1, load5, load15 = psutil.getloadavg()
mem = psutil.virtual_memory()
swap = psutil.swap_memory()
disk = psutil.disk_usage('/')
users = len(psutil.users())

# Attempt to get primary IPv4 address
ip_address = "Unknown"
try:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    ip_address = s.getsockname()[0]
    s.close()
except:
    pass

print(f"{CYAN}System information as of {datetime.now().strftime('%a %b %d %I:%M:%S %p %Z')}{RESET}\n")
print(f"  System load:  {load1:.2f}                Processes: {len(psutil.pids())}")
print(f"  Usage of /:   {disk.percent:.1f}% of {disk.total / (1024**3):.2f}GB   Users logged in: {users}")
print(f"  Memory usage: {mem.percent}%                 IPv4 address: {ip_address}")
print(f"  Swap usage:   {swap.percent}%\n")


# --- Tailscale IP ---
if shutil.which("tailscale"):
    try:
        tailscale_ip = subprocess.check_output(["tailscale", "ip", "-4"], text=True).strip()
        print(f"  Tailscale IPv4: {GREEN}{tailscale_ip}{RESET}")
    except subprocess.CalledProcessError:
        print(f"  Tailscale IPv4: {RED}Not available{RESET}")
else:
    print(f"  Tailscale IPv4: {YELLOW}Tailscale not installed{RESET}")


########### Get the Sessions ###########
check = subprocess.run(["tmux", "ls"], capture_output=True, text=True)

if "no server running" in check.stderr:
    print(f"{YELLOW}No tmux sessions running.{RESET}")
else:
    print(f"\n{CYAN}Active tmux sessions:{RESET}")
    for line in check.stdout.splitlines():
        name, rest = line.split(":", 1)
        # extract date from rest (inside parentheses)
        try:
            date_str = rest.split("created")[1].strip(" )")
            dt = datetime.strptime(date_str, "%a %b %d %H:%M:%S %Y")
            formatted_date = dt.strftime("%A, %B %d, %Y, %I:%M %p")
        except:
            formatted_date = "Unknown date"
        print(f"{GREEN}Session:{RESET} {name}  {YELLOW}{formatted_date}{RESET}")

########### Create The Session ###########
def tmux_up():
    name = input(f"\n{CYAN}Enter session name to attach or create:{RESET} ").strip()

    # list existing sessions
    result = subprocess.run(["tmux", "ls"], capture_output=True, text=True)

    sessions = []
    if "no server running" not in result.stderr:
        for line in result.stdout.splitlines():
            sessions.append(line.split(":")[0])

    # attach if exists, otherwise create (directly in current shell, no terminal)
    if name in sessions:
        subprocess.run(["tmux", "attach", "-t", name])
    else:
        if name:
            subprocess.run(["tmux", "new", "-s", name])
        else:
            subprocess.run(["tmux", "new"])


########### Keep the session on the loop ###########

while True:
    try:
        tmux_up()
        break
    except KeyboardInterrupt:
        break
    except:
        break


#!/bin/bash
ip=$(curl -s https://ifconfig.me/ip 2>/dev/null)
if [ -n "$ip" ]; then
    echo "Public IP: $ip"
fi

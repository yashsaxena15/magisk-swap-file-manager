#!/system/bin/sh

# Disable swap
swapoff /data/swap.img 2>/dev/null

# Delete swap file
rm -f /data/swap.img

# Delete log files
rm -rf /data/local/tmp/logs/
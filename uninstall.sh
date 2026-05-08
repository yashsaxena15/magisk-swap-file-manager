#!/system/bin/sh

# Disable swap
swapoff /data/swap.img 2>/dev/null

# Remove swap file
rm -f /data/swap.img

# Remove config
rm -f /data/adb/swap-manager.conf

# Remove logs
rm -f /data/local/tmp/logs/swap.log 
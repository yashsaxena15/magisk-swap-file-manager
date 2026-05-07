#!/system/bin/sh

swapoff /data/swap.img 2>/dev/null
rm -f /data/swap.img
rm -f /data/local/tmp/logs/swap.log 
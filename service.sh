#!/system/bin/sh

LOG=/data/local/tmp/logs/swap.log
CONFIG=/data/adb/swap-manager.conf

# Create log directory
mkdir -p /data/local/tmp/logs

echo "[$(date)] Swap script started" >> $LOG

# Load config
if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else
    echo "[$(date)] Config file missing!" >> $LOG
    exit 1
fi

SWAPFILE=$SWAP_FILE
SIZE_MB=$SWAP_SIZE_MB

# Wait until boot completed
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    echo "[$(date)] Waiting for boot completion..." >> $LOG
    sleep 5
done

# Extra wait for MIUI services
sleep 60

echo "[$(date)] Boot completed" >> $LOG

# Create swap file if missing
if [ ! -f "$SWAPFILE" ]; then
    echo "[$(date)] Creating swap file..." >> $LOG

    /system/bin/dd if=/dev/zero of=$SWAPFILE bs=1M count=$SIZE_MB

    chmod 600 $SWAPFILE

    /system/bin/mkswap $SWAPFILE

    if [ $? -eq 0 ]; then
        echo "[$(date)] Swap file created successfully" >> $LOG
    else
        echo "[$(date)] ERROR: mkswap failed!" >> $LOG
        exit 1
    fi
fi

# Disable old swap if active
swapoff $SWAPFILE 2>/dev/null

echo "[$(date)] Old swap disabled" >> $LOG

# Enable swap
/system/bin/swapon $SWAPFILE

if [ $? -eq 0 ]; then

    # Apply swappiness
    echo $SWAPPINESS > /proc/sys/vm/swappiness

    PRIO=$(awk '/swap.img/{print $5}' /proc/swaps)

    echo "[$(date)] Swap enabled successfully! Priority: $PRIO | Swappiness: $SWAPPINESS" >> $LOG
else
    echo "[$(date)] ERROR: swapon failed!" >> $LOG
fi

# Log current swap status
cat /proc/swaps >> $LOG

echo "---" >> $LOG
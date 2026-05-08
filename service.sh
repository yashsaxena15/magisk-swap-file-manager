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

SWAPFILE=/data/swap.img
SIZE_MB=$SWAP_SIZE_MB

# Wait until boot completed
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    echo "[$(date)] Waiting for boot completion..." >> $LOG
    sleep 5
done

# Extra wait for MIUI services
sleep 60

echo "[$(date)] Boot completed" >> $LOG

# Expected size in bytes
EXPECTED_SIZE=$((SIZE_MB * 1024 * 1024))

# Recreate if missing or wrong size
if [ ! -f "$SWAPFILE" ] || [ "$(/system/bin/stat -c%s "$SWAPFILE")" -ne "$EXPECTED_SIZE" ]; then

    echo "[$(date)] Creating/Recreating swap file..." >> $LOG

    # Disable old swap if active
    swapoff $SWAPFILE 2>/dev/null

    # Remove old file
    rm -f $SWAPFILE

    # Create new file
    /system/bin/dd if=/dev/zero of=$SWAPFILE bs=1M count=$SIZE_MB

    chmod 600 $SWAPFILE

    /system/bin/mkswap $SWAPFILE

    if [ $? -eq 0 ]; then
        echo "[$(date)] Swap file created successfully (${SIZE_MB}MB)" >> $LOG
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
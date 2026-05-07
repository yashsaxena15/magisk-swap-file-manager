#!/system/bin/sh

LOG=/data/local/tmp/logs/swap.log
SWAPFILE=/data/swap.img
SIZE_MB=1024

# Create log directory
mkdir -p /data/local/tmp/logs

echo "[$(date)] Swap script started" >> $LOG

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

    mkswap $SWAPFILE

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
    PRIO=$(awk '/swap.img/{print $5}' /proc/swaps)
    echo "[$(date)] Swap enabled successfully! Priority: $PRIO" >> $LOG
else
    echo "[$(date)] ERROR: swapon failed!" >> $LOG
fi

# Log current swap status
cat /proc/swaps >> $LOG

echo "---" >> $LOG
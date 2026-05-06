#!/system/bin/sh

LOG=/data/local/tmp/logs/swap.log

# checking log directory exists or not
mkdir -p /data/local/tmp/logs

echo "[$(date)] Swap script started" >> $LOG

# wait until /data folder mounts
until [ -f /data/swap.img ]; do
    echo "[$(date)] Waiting for /data to mount..." >> $LOG
    sleep 5
done

echo "[$(date)] /data mounted, swap.img found" >> $LOG

# additional wait
sleep 60

# disable swap if active already
swapoff /data/swap.img 2>/dev/null
echo "[$(date)] Old swap disabled (if any)" >> $LOG

# Enable
/system/bin/swapon /data/swap.img
if [ $? -eq 0 ]; then
    PRIO=$(awk '/swap.img/{print $5}' /proc/swaps)
    echo "[$(date)] Swap enabled successfully! Priority: $PRIO" >> $LOG
else
    echo "[$(date)] ERROR: swapon failed!" >> $LOG
fi

# Current swap log status 
cat /proc/swaps >> $LOG
echo "---" >> $LOG

